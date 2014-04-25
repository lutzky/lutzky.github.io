---
date: 2011-09-04 18:53:00
layout: post
title: Home network wiring
tags:
- networking
---
{% include JB/setup %}

I don't like wireless connections; they're always second-best, be it in terms
of security, speed, or reliability. Here's how my apartment looks (very
approximately):

     .-P1----.  .-------------------P4-,---------,
     |  PC   |  |       COMFY SOFA     .         |
     |       |  |                      . Closed  |
     |  .-,  |  |      Living room     . Porch   |
     |  |B| P2  |                      .         |
     |  |E|     |                      .         |
     |  |D|  |      HUGE CUPBOARD   TV .  R PC   |
     `-------'  `-P3-------------------'--P5-----'
       My room

The room on the left is mine, with my (constantly torrenting) PC in bed-viewing
position. The router (`R`) is in the closed porch, connected to my roommate's
PC. Wifi doesn't stand a chance through two walls and the porch's glass screen.
`P1` through `P5` are power outlets.

## First solution

Put a [reverse DD-WRT router][1] at P2 (with a cable going across the room from
the PC). Slow connection, not very reliable.  This worked well enough for
several months.

[1]: /2010/11/20/dd-wrt-awesomeness

## Second solution

Get a pair of [homeplugs](http://www.aztech.com/sg/homeplug_hl110e.html). Stick
one at P1 (connected through a power strip shared by the PC, speakers, screen
and guitar amp). Stick another at P5 (connected through a power strip shared by
the other PC, router, modem, TV, fan, printer, speakers and a lamp). It
_shouldn't_ work - but it does. It blinks red, is nowhere near the promised
200Mbps, but it's still faster (and more reliable) than my internet connection.
These homeplug devices are fantastic - they require literally no configuration
(unless you want to reconfigure the encryption keys) and work very well, I
highly recommend them.  The problem was when I got an Xtreamer - a cute device
to watch my shows on my living room TV (see: comfy sofa). Once I plug it in,
the homeplug connection dies on me, proverbially the last straw.

## Third solution

Thankfully, I have my Big Box of Electronic Junk, which contained a Super Long
(read: haven't measured it) network cable. Moved the homeplug to P3, hid the
cable behind the Huge Cupboard. Problem solved.  On a side note, I would have
preferred a [Boxee Box](http://boxee.tv), but sadly it doesn't support lame old
RCA connections.
