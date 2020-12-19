---
date: 2010-11-20 15:19:00
title: DD-WRT awesomeness
tags:
- networking
- hardware
---

Since I've last posted, I've moved to a new apartment. First order of business
- get a working internet connection. This is extra-challenging when your
primary machine doesn't even have a wireless network card.

My first hack used my trustee laptop - it has a properly working wireless card,
and could connect to my roommate's router quite easily. It runs Ubuntu, and as
it turns out, that means sharing the connection was dead-simple: Right-click on
the network manager icon, add a new wired connection called "Shared", and under
IPv4 settings, choose "Shared to other computers". That's it. Once I connected
my desktop to my laptop, it automatically got all of its settings, and I was
good to go.

However, this was kind of annoying - I had to leave my laptop on, the reception
in my room isn't perfect so it would sometimes disconnect (requiring manual
intervention), and my laptop wasn't free for ordinary use (if I wanted my
torrents to keep going).

The solution: I grabbed my (horrible) old D-Link DIR-300 router, and installed
DD-WRT on it. This gave it an awesome "client mode" feature, which allowed it
to use it the same way I used my laptop to bridge my wireless connection.
Flashing it worked quite well by following the guide (the updated version in
the wiki, that is - it has proper instructions for connecting to RedBoot, the
D-Link flashing interface, from Linux), and another guide helped me set up
Client mode. All seems well, except for two issues:

First, port forwarding doesn't seem to work properly - it works well on the
internal network (that is, I can SSH into my desktop using my laptop), but not
on the internet (SSH port shows up as open, but I can't connect). I'm also
guessing that UPnP/NAT-PMP won't work properly. Second, and this is an old
problem - the router has a high-pitched whine. This may have something to do
with the fact that the AC/DC adapter it came with is rated for 12V @ 1A,
whereas the router is rated 5V @ 1.2A. Let's hope it doesn't fry (hasn't for
the 3 years I used it).
