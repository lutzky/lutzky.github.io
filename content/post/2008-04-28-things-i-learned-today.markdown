---
date: "2008-04-28T21:10:00Z"
tags:
- linux
- git
- asides
title: Things I learned today
---

1. You can use git on a VFAT disk (for example, a USB key) without all of the
   annoying mode issues, by using the following setting in `.git/config`:

   ```
   [core]
   filemode = false
   ```

   What I haven't figured out is how to do force a chmod in this situation; for
   example, if I create a new script, I was hoping to be able to `git chmod +x`
   it.
2. [Cream](http://cream.sourceforge.net) is a very good editor if you're used
   to Windows applications. It's a set of plugins for VIM which make it
   modeless and (very) familiar to Windows users. However, Ctrl-O still has its
   usual job for us ordinary junkies :)
3. Vertically, two cans of Pepsi fit very snugly into a Pringles can.
