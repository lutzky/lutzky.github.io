---
date: 2009-02-26 22:15:00
layout: post
title: Hardware doesn't like me
tags:
- hardware
---

I'm a software kind of guy. Here's proof.

Today I went to visit my grandparents, and it turned out their computer
wouldn't boot. BIOS would load up fine, and I could browse the menus fine - but
once it tried to go on from there, it would simply blink what looked like half
a cursor (that is, half of a `_`-style cursor). I figured it might be the HDD -
so I took it home, and decided to connect it to my own box. Upon disconnecting
my DVD drive, I destroyed the SATA cord - it had an annoying little metal tab
which had to be pushed in before it would release, and it just wouldn't give,
and the connector just broke, exposing and bending the wires.

Checking if the computer still boots, the BIOS took much longer to display hard
drive status, and while Ubuntu would start booting, it would fail in the
process and tell me that my root hard drive (by UUID) isn't available. Looking
at dmesg, the ata2 module was indeed reporting that the hard drive was too slow
- but a few seconds later it would finally access the drive, and mount
properly. This problem, however, disappeared once I connected my grandparents'
drive! (Mounting it would fail, telling me that I either have a hardware error
or need to connect it to a Windows machine, which I don't have, and run some
diagnostic commands). Sure enough, when the HDD is connected by itself, it gets
quite flaky, but once I connect a second drive (back to the DVD, eventually),
everything works properly. This probably has to do with the fact that both
drives are connected on continuations of the same power cord - but I've never
experienced such a problem, where you _must_ connect devices to _both_
connectors on the power cord. A hardware guy I know says he's never heard of
such a problem either.

Naturally, these things never happen when I mess with hardware at work, where
there are plenty of spare parts...
