---
layout: post
title: "Fun with file descriptor leaks"
description: ""
category: 
tags:
- code
- linux
---

Here's a fun little bash script:

```bash
#!/bin/bash
(
  sleep 20 &
)
ps -f $(pidof sleep)
echo "Bye"
```

Run it, and you'll notice a few things: 

* Because the subshell running `sleep` dies immediately, `sleep` gets reparented to `init`. (Interestingly enough, on newer Ubuntu releases this isn't PID 1...), so the script doesn't have any child processes by the time it prints "Bye".
* After "Bye" is shown, the script exits immediately, returning control to the shell.

Now, call the script `pied_piper.sh`, and try the following:

```bash
./pied_piper.sh | cat
./pied_piper.sh | ts  # Awesome timestamping utility, same problem though
ssh localhost ./pied_piper.sh
```

Annoying, isn't it? These commands won't finish for 20 seconds! The problem is that `sleep` is keeping its `stdout` open, which is the input pipe for `cat`, `ts`, `ssh`, or whatever else you're piping to (this is very annoying on Jenkins jobs as well).

If a third-party product is pissing you off this way - that is, it died, but somehow still keeps its pipe open, you can find the culprit like so:

```bash
fuser -v /proc/$PID_OF_PROCESS_WITH_OPEN_PIPE/fd/0
```

This will usually yield a `sleep` process as the culprit, with the useless parent information of `init` (as per my example). The only information you have is the precise delay - in my experience, it helps to find all "sleep" commands lurking about, and tinker with the delay amounts: Found a `sleep 30`? Change it to `sleep 29`, see if that's what shows up.

Here's how to actually fix the problem:

```bash
#!/bin/bash
(
  sleep 20 >&- 2>&- <&- &
)
ps -f $(pidof sleep)
echo "Bye"
```

This will close `stdout`, `stderr` and `stdin`. As a friend pointed out, it's often safer to do `> /dev/null` rather than `>&-`, as some processes will crap out if they don't have some semblence of an `stdout`. However, `>&-` is shorter, faster, and perfectly safe for `sleep`.

Of course, it's better to save the PID for this `sleep` and kill it when appropriate from within the script - otherwise, you might be accumulating many useless `sleep` processes.
