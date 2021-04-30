---
date: "2007-09-18T11:27:00Z"
tags:
- git
title: Really liking this git thing
---

I've been a very big proponent of Subversion so far, especially as a tool for
collaborating on coding homework. However, I've recently been trying out
Linus's [git](http://git.or.cz/). It's very nice so far, and really seems to be
catching on. Some good points:

* Fast as all hell (much faster than Bazaar, although I haven't given that the
  proper attention)
* No need for a central server; hell, no need for an internet connection at
  all, everything can be done over USB keys or whatnot
* No real need to configure any special server; just install git on it
* Very nice alternative to configuring write-control for all of the users
* Very easy branching and merging, finally! SVN really shows its weakness here

One thing I couldn't find out how to do is limiting read-access to git
repositories without special server configuration. It would be nice if git had
support for `.htpasswd`-compatible authentication, those are pretty easy to use.
