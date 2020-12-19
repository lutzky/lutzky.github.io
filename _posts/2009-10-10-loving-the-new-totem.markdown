---
date: 2009-10-10 13:04:00
title: Loving the new Totem
tags:
- show downloading
---

Totem is Gnome's built-in media player, and it really annoyed me in previous
versions, and had me switching to VLC. However, the version included in the
Ubuntu 9.10 release candidate has two features which are very important, in my
opinion. The first feature is smooth graphical integration with compositing
managers (such as compiz). In previous versions, as well as VLC, once you
fullscreen the window, moving the mouse (which causes the cursor and the
partial interface to appear) causes a very annoying flicker. This has been
fixed (at least on my box, using an NVidia card).

The second, more important feature, is the exact one I've been missing and
talked about in [the previous post][1] - hit Edit -> Preferences -> Start
playing files from last position, and Totem will keep track of your last
playback position when you close the video. Reading [the implementation
patch](http://article.gmane.org/gmane.comp.gnome.svn/223873) shows that there
is a certain threshold for this - the position won't be saved if you're too
close to the beginning or end of the video. So there, my show downloading stack
now has every feature I'd want from Miro, without the downsides I've mentioned.

[1]: /2009/09/05/my-show-downloading-stack
