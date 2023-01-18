---
title: "Preloading disk encryption keys"
date: 2022-01-26T21:30:22Z
summary: How to enter passphrases BEFORE rebooting your server
tags: ["software"]
---

<!-- markdownlint-disable MD013 -->

I run a small home server, which - among other things - has backups of data from cloud providers, in case I lose access to them; this data is sensitive and should therefore be encrypted. However, disk encryption requires a secret, and there are - generally speaking - four ways to go about that:

- Store the key on the same server as the encrypted disk
- Store the key on detachable media, attached to the same server as the encrypted disk
- Store the key on a different server
- Store the key in your brain (this is known as a "passphrase" or "password")

Using a separate server is a bit more complicated than I'd like to go (and is not always supported, e.g. in the free version of TrueNAS Core), and storing the key on the same server won't protect me in case the server is stolen. For my usecase, it's an easily burgler-accessible NUC. Detchable media will have to remain attached, as I want to be able to reboot remotely (I've heard some interesting suggestions, e.g. "store the key in a USB key glued to your desk so the burgler will probably just disconnect it from the server"). The last option is the simplest and most convenient, except when rebooting.

When rebooting an encrypted system that uses a passphrase, you essentially have to do the following:

1. Learn that a reboot is required (about once every 12 days on my server, for a kernel security update)
2. Connect to the server to reboot it
3. Wait for it to reboot
4. Connect to the server again to input the passphrases

I always hate actions with a "wait" part to them, so I figured - wouldn't it be nice to input the passphrases as part of the reboot process? That way I essentially shave off steps 3 and 4. The idea is to allow _just the next boot_ to load the encrypted bits without entering any passwords, authorized by, well, someone who knows the relevant passwords. Hopefully burglars aren't sophisticated enough to target my machine on kernel patch days.

My particular system uses ZFS-on-linux with a couple of encrypted filesystems, and the following is an implementation using systemd and Go. I do think the idea is useful enough for other passphrase-encrypted systems (e.g. LUKS).

The overall design is:

1. Before rebooting, you run the go binary on the server as root. It will:
   1. Figure out which ZFS filesystems currently have a loaded key
   2. Ask for the password for those (and check that it's correct)
   3. Create `/zfs-reboot-passphrase.sh` with the passphrases embedded
      - `shellescape` turns out to be useful, as `fmt.Sprintf("%q", password)` insists on using double quotes, which doesn't prevent bash from interpreting strings.
2. On boot, the `zfs-reboot-passphrase` systemd service will check if `/zfs-reboot-passphrase.sh` exists and run it. It will:
   1. Load the embedded passphrases and mount the relevant filesystems
   2. `shred -u` itself - rewrite itself with random data to prevent undeletion, and then delete itself.

The specific implementation isn't super-clean nor important, but I'm attaching it as-is (buyer beware) for completeness. Hopefully it serves as inspiration for something useful.

**`/lib/systemd/system/zfs-reboot-passphrase.service`:**

```ini
[Unit]
Description=Mount remaining ZFS filesystems with passphrase
After=zfs.service
ConditionPathExists=/zfs-reboot-passphrase.sh

[Service]
Type=oneshot
ExecStart=/zfs-reboot-passphrase.sh

[Install]
WantedBy=multi-user.target
```

**`load_keys.tmpl`:**

```bash
#!/bin/bash

{{ range $path, $password := .}}
echo {{ $password }} | zfs load-key {{ $path }}
{{ end }}

{{ range $path, $password := . }}
zfs mount {{ $path }}
{{ end }}

exec shred -u $0
```

**`main.go`:**

```go
package main

import (
  "embed"
  "flag"
  "fmt"
  "io"
  "os"
  "os/exec"
  "os/user"
  "strings"
  "text/template"

  "golang.org/x/term"
  "gopkg.in/alessio/shellescape.v1"
)

var (
  //go:embed *.tmpl
  templatesFS embed.FS
  templates   = template.Must(template.ParseFS(templatesFS, "*.tmpl"))

  skipPasswordCheck = flag.Bool("skip_password_check", false, "Do not check entered passwords")
  outputFile        = flag.String("output_file", "/zfs-reboot-passphrase.sh", "Write output to this file (blank is stdout)")
)

func main() {
  flag.Parse()

  mustBeRoot()

  fileSystems, err := fileSystemsWithKeyStatus()
  if err != nil {
    panic(err)
  }

  templateData := map[string]string{}

  for _, fs := range fileSystems {
    if password := getPassword(fs); password != "" {
      templateData[fs] = shellescape.Quote(password)
    } else {
      fmt.Fprintln(os.Stderr, "Skipping", fs)
    }
  }

  var out = os.Stdout
  if *outputFile != "" {
    var err error
    out, err = os.OpenFile(*outputFile, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0700)
    if err != nil {
      panic("Can't write to " + *outputFile + ": " + err.Error())
    }
  }

  templates.Execute(out, templateData)
  if out != os.Stdout {
    fmt.Fprintln(os.Stderr, "Wrote", *outputFile)
  }
}

func getPassword(fs string) string {
  for {
    fmt.Fprintf(os.Stderr, "Password for %s (empty to skip): ", fs)
    pass, err := term.ReadPassword(int(os.Stdin.Fd()))
    fmt.Fprintln(os.Stderr)

    if err != nil {
      continue
    }

    if len(pass) == 0 {
      return ""
    }

    if err := checkPassword(fs, string(pass)); err != nil {
      fmt.Fprintf(os.Stderr, "Password mismatch: %v\n", err)
      continue
    }

    return string(pass)
  }
}

func mustBeRoot() {
  u, err := user.Current()
  if err != nil {
    panic("Could not check I'm root")
  }
  if u.Uid != "0" {
    panic("Must run as root")
  }
}

func fileSystemsWithKeyStatus() ([]string, error) {
  var result []string
  keyStatus, err := exec.Command("zfs", "get", "-H", "-t", "filesystem", "keystatus").Output()
  if err != nil {
    return nil, fmt.Errorf("failed to check filesystems with keys: %w", err)
  }
  for _, line := range strings.Split(string(keyStatus), "\n") {
    spl := strings.Fields(string(line))
    if len(spl) >= 2 && spl[2] == "available" {
      result = append(result, spl[0])
    }
  }

  return result, nil
}

func checkPassword(fs, password string) error {
  if *skipPasswordCheck {
    return nil
  }
  cmd := exec.Command("zfs", "load-key", "-n", fs)
  stdin, err := cmd.StdinPipe()
  if err != nil {
    return fmt.Errorf("failed to send password to zfs load-key: %w", err)
  }
  go func() {
    defer stdin.Close()
    io.WriteString(stdin, password)
  }()
  if output, err := cmd.CombinedOutput(); err != nil {
    return fmt.Errorf("password verification failed: %s", strings.TrimSpace(string(output)))
  }

  return nil
}
```
