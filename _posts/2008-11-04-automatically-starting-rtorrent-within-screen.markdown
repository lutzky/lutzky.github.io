---
date: 2008-11-04 21:33:00
layout: post
title: Automatically starting rtorrent within screen
tags:
- linux
---

These days I don't stay at home often, but I do have an RSS/BitTorrent combo
fetching me all kinds of neat stuff for me, so I can have it ready for me on
the weekend. I love [rtorrent](http://libtorrent.rakshasa.no/), especially due
to the fact that I can run it in `screen`, ssh home and see how things are
doing (or add more torrent to the download). However, sometimes my net
connection breaks down, computers gets shut off, or things like that. This week
my router broke down, so I can't even ssh home to manually start up rtorrent.
My solution: A small script, which checks whether rtorrent is already running,
and if not - runs it in a detached screen session. Run this with your favorite
`cron` software.

```bash
#!/bin/bash
# A simple script to make sure I am running rtorrent in a screen

if ! ps -o uname -C rtorrent | grep -q `whoami`; then
	screen -d -m rtorrent
fi
```
