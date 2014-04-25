---
date: 2007-04-19 15:44:00
layout: post
title: Grub menu.lst editor
tags:
- linux
---
{% include JB/setup %}

A lot of people ask me how to change the default operating system booted after
installing Linux. The answer they get in Ubuntu's case, "Edit
`/boot/grub/menu.lst`, it's self-explanatory", is often unsatisfactory.
Attached is the solution :)

> Actual script lost in the mists of time...

Download the file, open a terminal, and run `gksudo python grubmenu.py`

I'll try and make a package of this soon, so it becomes a menu entry and that
much easier to use.
