---
title: "Clevis & Tang on Proxmox"
summary: "Encrypted servers for your homelab, with even less passphrase-typing!"
subtitle: "Encrypted servers for your homelab, with even less passphrase-typing!"
slug: clevis-tang-proxmox
date: 2026-02-12
tags: ["networking", "security"]
resources:
- name: "featured-image"
  src: "hero.webp"
---

<!-- markdownlint-disable MD052 -->

<!-- cSpell: word Shamir LUKS Technion homelab oneshot -->

I run a few small home servers, some of which contain sensitive personal
backups. I want to protect against the "physical server burglary" threat
vector, but also want to avoid entering passwords as much as I can. In [a
previous post][preload-key], I set up an "enter password before rebooting"
mechanism, that works reasonably well if you *know in advance* you're going to
reboot. I've since refined my approach, and am happier with the solution.

[preload-key]: {{< ref "posts/preload-key" >}}

The main idea is using [clevis and tang](https://github.com/latchset/clevis).
This is a system that allows a variety of encryption systems (including
whole-disk LUKS encryption) to decrypt themselves using a network host running a
"tang" server. This server doesn't actually hold the full keys - instead, *Superb
[Shamir](https://en.wikipedia.org/wiki/Adi_Shamir) Shenanigans* are used to share
the secret between the client and server, so both need to be available for
decryption.

{{< admonition type=note title="Fun note" >}}
When I was an undergrad in the Technion IIT, circa 2005, Prof. Shamir came by
for a colloquium about using the CPU cache to obtain keys from other processes
running on the machine; he was probably outlining his paper [Cache Attacks and
Countermeasures: the Case of AES](https://eprint.iacr.org/2005/271.pdf).
Because this was for an undergrad audience, he gave a quick introduction about
how CPU caches work; the entire talk was easy-to-follow and super-engaging.
Later that day, we had an ordinary "computer architecture" class, where the
professor struggled to explain, in two hours, how a CPU cache works - to a
lower level of detail than Shamir's talk, and much less clearly. This is not a
dig at the second professor - Shamir is just that good.
{{< /admonition >}}

I run my various homelab servers as VMs on a [proxmox] host. Specifically, I
run:

[proxmox]: https://www.proxmox.com

* Several non-encrypted machines, so any outage in the decryption system doesn't
  affect their reliability
* A tang host, whole-disk encrypted with LUKS, which requires a passkey on boot
* One or more "ordinary" encrypted machines (also whole-disk encrypted with
  LUKS), which, on boot, look for the tang host for decryption[^also-passkey]

[^also-passkey]: Just in case, these can also be decrypted with a passkey

This system is quite effective:

* If anyone steals my machine, even though it includes the tang server, it'd
  still be useless to them - they wouldn't be able to boot it.
* If I reboot any VM, including the "ordinary" encrypted machines, no password
  is required.
* A password *is* required for rebooting the tang host - but since that's *all*
  it runs, it's very rare I need to reboot it. Thanks to [LivePatch], it even
  gets kernel updates without rebooting.
* If I need to reboot the entire proxmox host, all non-encrypted machines will
  still work immediately. Because proxmox itself is accessible (with my
  password), I can remote in and input the passphrase for the tang host.

[LivePatch]: https://ubuntu.com/security/livepatch

{{< admonition type=warning title="Important" >}}
Although you can use the proxmox mobile app to input the password on the tang
host, it (at the time of writing) seems to handle the "shift" key incorrectly;
I just use a (longer) passphrase which doesn't require that key (i.e. mostly
lowercase letters, dashes, numbers).
{{< /admonition >}}

Clevis and tang can also be used outside of LUKS. I've cobbled together some ZFS
support, which I run on my NAS. First, I create my half-key local file:

```shell
$ read -s | clevis encrypt tang \
    '{"url":"http://tang-server.localdomain"}' -y > zfs_key.jwe
$ sudo install -o root -m 600 zfs_key.jwe /etc/zfs_key.jwe && \
    rm zfs_key.jwe
```

Then I create this systemd unit to load that key:

```systemd
[Unit]
Description=Load ZFS encryption keys
DefaultDependencies=no
After=network-online.target zfs-import.target
Wants=network-online.target zfs-import.target
Before=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
# God knows why it takes multiple attempts, but it does
ExecStart=/bin/sh -c "for i in $(seq 1 30); do \
    cat /etc/zfs_key.jwe | clevis decrypt | zfs load-key -a && exit 0; \
    sleep 1; done; exit 1"
# We can't have Before=zfs-mount.service, as that creates a loop.
# Instead, let's do more mounting here.
ExecStart=zfs mount -a -v -l

[Install]
WantedBy=zfs-mount.service
```

With zfs as well, I can still manually input the key if necessary; I keep my
keys in [VaultWarden] as well, meaning they're backed up on multiple
devices.

[VaultWarden]: https://github.com/dani-garcia/vaultwarden

Overall, this seems like a fairly solid tradeoff between security, reliability,
and convenience. It is significantly more robust than [my previous
solution][preload-key], and I'm quite happy with it.
