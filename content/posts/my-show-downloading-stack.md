---
date: "2009-09-05T13:42:00Z"
slug: my-show-downloading-stack
aliases: ["/2009/09/05/my-show-downloading-stack/"]
tags:
- show downloading
title: My show downloading stack
---

I love watching TV, and hate it. Regular show schedules are horrible,
commercial breaks are annoying, and the ability to rewind is very important. I
love Hot's VOD service (and happily pay to watch the shows I enjoy), but my
true favorite for getting my entertainment is everyone's favorite
not-a-dumptruck, the internet. In this post, I will describe how I do it.

Everything I describe in this post can be done using
[miro](http://getmiro.com/). It's a neat piece of software, which lacked polish
in version 2.4 (2.5 is out now though), but there are a few things I don't like
about it:

* You have to be graphically logged in for it to run. Among other things, this
  means that if someone reboots your computer, there's no way to get it to
  start automatically. (I'll be very happy to know if I'm wrong about this)
* It doesn't give you as much control as I'd like over torrents.
* Its BitTorrent client doesn't perform as well as rtorrent.

However, Miro does one thing which I haven't figured out how to do myself yet:
It keeps track of your position within watched shows. That is, stop watching a
show -and next time playback will resume from the same place.

The first thing you want to do is get a good RSS feed for your show.
Unfortunately, [Revision3](http://revision3.com/)'s shows (many of which are
quite good), are direct HTTP download links, as per the advertiser's request.
For other shows, you can find torrent RSS feeds, which make much better use of
everyone's bandwidth. Also, downloading will be handled by our trusty rtorrent,
which we can configure for bandwidth limiting.

To download RSS feeds, I use [flexget](http://flexget.com/). It does its job
well, but doesn't support bandwidth limiting. It accepts a simple YAML
configuration file, and has good logging. I run it as a cron job - its locking
mechanism prevents multiple instances from running simultaneously. For
non-torrents, I set the output directory to `~/torrents/inbox`. For torrents, I
set the output directory to `~/torrents/from_rss`.

For downloading torrents, I use [rtorrent](http://libtorrent.rakshasa.no/).
It's a curses-based client which performs very well. My `.rtorrent.rc` file looks
like this:

```plaintext
download_rate = 30
upload_rate = 2
directory = /home/ohad/torrents/in_progress
on_finished = move_complete,"execute=mv,-u,$d.get_base_path=,~/torrents/inbox/ ;d.set_directory=~/torrents/inbox/"
session = /home/ohad/torrents/.session
schedule = watch_directory,5,5,load_start=/home/ohad/torrents/from_rss/*.torrent
schedule = untied_directory,5,5,remove_untied=
schedule = throttle_1,23:00:00,24:00:00,download_rate=0
schedule = throttle_2,05:00:00,24:00:00,download_rate=30
port_range = 6881-6889
encryption = allow_incoming,enable_retry,prefer_plaintext
dht = auto
peer_exchange = yes
scgi_local = /tmp/rtorrent-scgi.socket
```

Interesting things to note here are:

* Downloads live in one directory, but get moved to the inbox directory when
  they're done.
* The session directory is important - this allows rtorrent to resume downloads
  if it's shut down.
* The `from_rss` directory is watched for new torrent files. When the relevant
  downloads are stopped, `remove_untied` occurs and the torrent files are
  deleted.
* Throttling is fully customizable.
* The SCGI socket is useful for `rtgui` - we'll get to that.

I have a "watchdog"-style cron job which makes sure it's running if the
computer is up. This is not as elegant as starting it from an RC-script, but
keeps the whole setup confined to the limits of my own user. Again, rtorrent
has a lock-file which prevents multiple instances from running.

```bash
#!/bin/bash

# A simple script to make sure I am running rtorrent in a screen

set -e

SCGI_SOCKET=/tmp/rtorrent-scgi.socket
SESSION_DIR=~/torrents/.session

screen -d -m -fn -S rtorrent -s /bin/bash -t rtorrent -m nice rtorrent

while [[ ! -S $SCGI_SOCKET ]]; do sleep 1; done

if [[ -S $SCGI_SOCKET ]]; then
    chgrp www-data $SCGI_SOCKET
    chmod g+rwx $SCGI_SOCKET
fi
```

[RTGUI](http://code.google.com/p/rtgui/) provides a nice web-based interface.
It's a bit tricky to configure, and you'll need to use an HTTP server -
preferably lighttpd, as it has support for SCGI UNIX sockets (as opposed to
SCGI TCP sockets). This lets you keep the number of open network ports to a
minimum. This is all well-documented on the RTGUI site.

Finally, I've written a little python script called
[check_shows](http://github.com/lutzky/check_shows) which uses `libnotify` to
show a pretty pop-up whenever downloads complete. It's a tiny little hack which
uses inotify, which is lots of fun.

That's it. Any neat tricks are welcome :)
