---
date: "2009-10-31T02:32:00Z"
tags:
- hardware
- phones
title: Broken phone screen - data rescue
---

Last weekend I broke my Nokia 6120's screen. I have a military phone, which is
far cheaper, so I've decided to keep it offline. However, being the sentimental
guy that I am, I did want to save all of my contacts and SMS messages (in
addition to the photos, which presented less of a problem). This proved to be a
bit of a challenge without the screen working.

Usually, when you connect the phone via USB, it asks if you want "PC Suite
mode" or "Data Transfer mode". The "Data Transfer" mode has the phone show up
as a standard USB storage device, which allows for easy transfer of MP3 files,
photos and videos to and from the phone, without any nokia-specific software.
However, it only works for the external SD card, so you can't use that to
access SMS messages or contacts.

I usually only need "Data Transfer" mode, so I changed the default to that.
Today I regret that decision, as it cost me a couple of hours' work. I called
the Orange hotline, and they did their best to help me, including trying to
blind-guide me through the menus, which failed because the menus are actually
dynamic and I didn't have the default setup. They actually got me 90% of the
way there - here's the solution I found: Hit the red (disconnect) button, and
type the Soft Reset GSM code: `*#7780#`. Now press the "left menu" key (not the
left key, nor the menu key - the left of the two "dynamic" keys) - this part
was what the Orange hotline missed, because it seemed so obvious. Then hit
12345 (this is the default "secret code"), and the left menu key again. I found
this by watching a demo of the soft reset on YouTube.

At this point I used VirtualBox and the Nokia PC suite (both are
free-as-in-beer) to do the heavy lifting. I now have a text file with all of my
contacts, a CSV file with all of my SMS messages, and all of my images saved
both to my computer and a DR site. Now I just need to upgrade my military phone
(Mirs)...
