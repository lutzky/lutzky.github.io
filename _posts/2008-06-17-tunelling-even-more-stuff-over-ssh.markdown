---
date: 2008-06-17 12:32:00
layout: post
title: Tunelling even more stuff over SSH
tags:
- networking
---

Today at the CS department of the Technion is a particularily Bad Network Day
(TM) for laptop users; none of the wired connections at the farm work, and
wireless doesn't seem to working for HTTP at all.  
  
It does, however, work for SSH. Ka-ching! :)  
  
Tunneling your browser over SSH is a pretty simple affair - SSH into somewhere
which has a decent connection, and use the -D9999 flag (9999 works, but it can
be any 16-bit number over 1024). Then, configure your browser to work over a
SOCKS proxy at 127.0.0.1:9999.  
  
How do you, however, get other things to work over that tunnel? There's an
excellent program called dante-client (that's an apt package, folks. if you
can't apt-get due to your network situation, get it at packages.ubuntu.com or
packages.debian.org). Install it, and make sure `/etc/dante.conf` has the
following lines:  
  
    route {
        from: 0.0.0.0/0   to: 0.0.0.0/0   via: 127.0.0.1 port = 9999
        protocol: tcp
        proxyprotocol: socks_v4 socks_v5
    }

Then, run `socksify whatever-you-want-to-do`. For example, `sudo socksify
apt-get install something`. Or perhaps `socksify ssh somewhere`. Or `sudo wget
something`. Or `socksify git do-something-awesome`. (All of the above work for
me)
