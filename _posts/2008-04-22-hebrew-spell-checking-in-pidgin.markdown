---
date: 2008-04-22 14:13:00
layout: post
title: Hebrew spell-checking in Pidgin
tags:
- linux
---

This one took me a while to figure out, which is reason enough to post it here.
  
First of all, you'll need `aspell-he`, as pidgin uses `gtkspell` (which, in
turn, uses `aspell`) rather than `enchant` (which supports `hspell`). There is
a patch for `gtkspell` which gets it to use `enchant`, but I don't know of a
simple way to get it to work in my distribution of choice, Ubuntu.  
  
Now you need a neat little plugin from the
[Guifications](http://plugins.guifications.org/) plugin pack, called
SwitchSpell. Unfortunately, it's in version 2.3.0 of the pack, whereas the
current Ubuntu version is 2.0.0. It's not complicated to install this from
source though: I've detailed the precise installation procedure below; the
confusing thing is that if you forget to install `libgtkspell-dev` or
`libaspell-dev`, SwitchSpell will not be built, but the `configure` script
tells you that it _will_.  
  
    sudo apt-get install build-essential gettext libgtkspell-dev libaspell-dev pidgin-dev
    wget http://downloads.guifications.org/plugins//Plugin%20Pack/purple-plugin_pack-2.3.0.tar.bz2
    tar jxvf purple-plugin_pack-2.3.0.tar.bz2
    cd purple-plugin_pack-2.3.0
    ./configure --with-plugins=switchspell
    make
    sudo make install

At this point, the Switch Spell plugin should show up in your Pidgin
preferences. When you activate it, you should get a menu at the top of each
conversation for choosing the dictionary in use. Enjoy!
