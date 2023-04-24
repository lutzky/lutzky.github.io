---
date: "2008-11-10T23:01:00Z"
slug: another-ssh-trick
aliases: ["/2008/11/10/another-ssh-trick/"]
tags:
- networking
title: Another SSH trick
---

Ever have a machine you can only ssh into through another machine? It's a very
common situation in the Technion. Here's one way to get around it: Assume you
can directly ssh into `alpha`, and from `alpha` you can ssh into `beta`. Have
the following code in your `~/.ssh/config`:

```
Host beta
        Hostname 1.2.3.4  # IP Address of beta
        ProxyCommand ssh alpha nc -w 1 %h %p
```

This requires you to have `nc` (netcat) installed on `alpha`. Once you do that,
you can run `ssh beta` directly from your own box.
