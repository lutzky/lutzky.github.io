---
date: "2018-08-04T00:00:00Z"
slug: ioutil-yakshave
aliases: ["/2018/08/04/ioutil-yakshave/"]
summary:  How I had to fix zimmski/osutil in order to write the Mutation Testing post.
title: The osutil yakshave
---

<!-- markdownlint-disable MD013 -->

I've been planning to write a blog post about *Mutation Testing*, and finally got around to it a couple of weeks ago. I set up my example, and looked to some publicly-available mutation testing tools for my programming language of choice, Go (I get to use it quite often as an engineer in Google). The best-maintained one appears to be [go-mutesting](https://github.com/zimmski/go-mutesting), so I figured I'll try it out. Unfortunately, I ran into a build issue with one of its depdencies:

```text
../../../github.com/zimmski/osutil/capture.go:79: cannot assign to _Cmacro_stderr()
../../../github.com/zimmski/osutil/capture.go:79: cannot assign to _Cmacro_stdout()
../../../github.com/zimmski/osutil/capture.go:103: cannot assign to _Cmacro_stderr()
../../../github.com/zimmski/osutil/capture.go:103: cannot assign to _Cmacro_stdout()
```

[Yak shaving](https://en.wiktionary.org/wiki/yak_shaving) time! This was covered in [zimmski/osutil#8](https://github.com/zimmski/osutil/issues/8), which showed it was an incompatibility with Go 1.10.

### Testing the issue

It turns out there's a really convenient way to check this using Docker (which I finally took the time to learn for the [umpteenth iteration](https://github.com/lutzky/wamc) of [the show downloading stack](/2011/12/15/the-show-downloading-stack-part-n1/)):

```shell
docker run -it --rm golang:1.9 go get -v github.com/zimmski/osutil
```

This will download a minimal image for getting (using git), building, and running Go code, extract it, get the `zimmski/osutil` package, run the tests (successfully), and clean up after itself, leaving no trace on your system other than the cached base image for `golang:1.9`. Change the `1.9` to a `1.10` and the process will be identical, except for the version of Go, and fail. In my opinion that's pretty astoundingly convenient, especially as the whole thing takes just under 38 seconds. We're cheating here, of course - docker needs to be preinstalled, and you could solve this in other ways (e.g. [gvm](https://github.com/moovweb/gvm)). However, docker is pretty ubiquitous nowadays (Google Cloud Shell conveniently includes it), and this method does have the benefit of testing on a completely clean image (no surprise dependencies).

We can use a similar technique to test our fix, once we have it: On the host, `go get github.com/zimmski/osutil`, and from the downloaded directory, run:

```shell
docker run -it --rm -v $PWD:/go/src/github.com/zimmski/osutil golang:1.10 \
  bash -c "cd /go/src/github.com/zimmski/osutil; go get -t -v; go test -v"
```

This will mount the current directory into the `GOPATH` of the docker image (conveniently at `/go`), get the required dependencies, and run our tests. You could modify this one-liner to not remove the image every time, but seeing as it only takes 7 seconds on consequent runs, I didn't bother.

### The issue and the fix

The root cause here is in `capture.go`, which provides the `Capture` and `CaptureWithCGo` functions. These get a `func()` callback, capture whatever it outputs to `stdout` and `stderr`, and return them as a string. The `Capture` function only works with pure Go code, and `CaptureWithCGo` is meant to support code that includes CGo as well. The latter assumes that the CGo code would use the C `stdout` and `stderr` globals (which are `FILE *` pointers which are used by `printf` and `fprintf`), so it creates a pipe and points `stdout` and `stderr` at it. This has two problems:

1. Assigning to `stdout` and `stderr` is no longer allowed in Go 1.10 (and, according to [golang/go#25221](https://github.com/golang/go/issues/25221), was never *intentionally* allowed).
1. Functions could output to standard output and error in other ways, such as calling external programs or using the `write` system call. This is true for the `Capture` function as well, but I wanted to modify as little behavior as possible.

Technically, the behavior-preserving solution could be to just use `freopen` instead, but I didn't know about it at the time. In general, capturing output using redirects seems to me like it should capture *all* output, regardless of how it's generated.

To accomplish this, let's first have a look a how shells accomplish redirects.

```shell-session
$ strace -f bash -c '/bin/echo hello > /tmp/redirected'
...
[pid 20210] openat(AT_FDCWD, "/tmp/redirected", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
[pid 20210] dup2(3, 1)                  = 1
[pid 20210] close(3)                    = 0
[pid 20210] execve("/bin/echo", ["/bin/echo", "hello"], 0x556c1736e260 /* 30 vars */) = 0
...
```

Here, strace runs a parent bash process (pid 20209, not shown in the trace above), which forks into PID 20210 which ultimately ends up running `/bin/echo` (and not the `echo` bash builtin). To accomplish the redirect, bash does the following:

1. Open the requested file, which ends up being file descriptor 3.
1. Use the `dup2` system call to overwrite file descriptor 1 (standard output) with the same file descriptor as 3. Now this open file has two descriptors pointing at it.
1. Close file descriptor 3; this reduces the number of file descriptors pointing at `/tmp/redirected` back to one.
1. Finally, uses `execve` to replace the running program with `/bin/echo`, which will (as always) output to file descriptor 1, which now points to `/tmp/redirected`.

No matter how `echo` internally causes output to appear (even if it ran yet another binary), the output would always go to `/tmp/redirected`.

It's worth mentioning that the `dup` system call is similar to the `dup2` system call, but the caller doesn't choose the destination file descriptor; instead, the first available file descriptor is used and returned.

This technique is the basic one behind [the fix][fix-commit]. The old method was, roughly:

1. Save the old `os.Stdout`, `os.Stderr`, `C.stdout`, and `C.stderr` objects
1. Open a pipe - this gets you two file descriptors (`w.Fd()` and `r.Fd()`)
1. Point the Go objects `os.Std{out,err}` at `w.Fd()` by just assigning `w` to them
1. Point the C objects `C.std{out,err}` at `w.Fd()` by opening it with `fdopen` and assigning the result to them. (This no longer works)
1. Call the callback function
1. Copy from the `r` end of the pipe to a buffer using `io.Copy`.
1. When the method returns (using `defer`), restore the four objects we saved

The new technique is, roughly:

1. Use `syscall.Dup` to save file descriptors 1 and 2 (standard output and error)
1. Open the pipe as before
1. Use `syscall.Dup2` to overwrite file descriptors 1 and 2 with `w.Fd()`
1. When the method returns, restore the original file descriptors
1. Call the callback function
1. Close *all* instances of the `w` end of the pipe
1. Copy from the `r` end of the pipe to a buffer using `io.Copy`.
1. WHen the method returns, restore the original file descriptors 1 and 2

When closing *all* instances of the `w` end of the pipe, this means `w.Fd()`, `syscall.Stdout`, and `syscall.Stderr`. If any of those three stays open, the underlying file descriptor will still count as open, and `io.Copy` will never return.

To demonstrate this, let's take a look at a simplified version (no error handling, don't try this at home):

```go
const closeStdout = true

func capture() string {
        r, w, _ := os.Pipe()

        oldStdout, _ := syscall.Dup(syscall.Stdout)

        syscall.Dup2(int(w.Fd()), syscall.Stdout)
        log("Writing to stdout (actually to pipe)")

        fmt.Print("Hello, world!")

        log("Closing write-end of pipe")
        w.Close()

        if closeStdout {
                log("Closing stdout")
                syscall.Close(syscall.Stdout)
        }

        var b bytes.Buffer

        log("Copying from pipe to buffer")
        io.Copy(&b, r)

        log("Restoring stdout")
        syscall.Dup2(oldStdout, syscall.Stdout)

        return b.String()
}
```

With `closeStdout` set to true, everything works correctly. However, with it false, `io.Copy` will hang.

The full code is in [the playground](https://play.golang.org/p/Xg2iajdiuNN), but because of [golang/go#24610](https://github.com/golang/go/issues/24610), for which the fix has yet to be rolled out, `Dup2` will fail, so you need to copy the code over to your local machine.

[fix-commit]: https://github.com/zimmski/osutil/pull/9/commits/f15804f0e6285e5634cf78f703ca544a6936a8fa
