---
date: 2007-02-26 16:26:00
layout: post
title: Before reinstalling your server for RAID
tags:
- hardware
---
{% include JB/setup %}

Check that the RAID it supports is actual Raid. My experience today:

1. Decide that secondary server should gradually become more and more primary
2. Decide that since it has two 160GB hard drives and built-in RAID, we should use that for mirroring
3. Mail (both!) users of the secondary server that it'll be down for rebuilding
4. Set up RAID array from BIOS, clearing all old information
5. Insert installation CD
6. Notice that installation still sees two hard drives
7. Discover that built-in NVRaid is actually software RAID
8. Disable built in RAID in favor of LVM, proceed to reinstall :(
