---
date: 2008-07-11 11:33:00
title: Been working on TTime
tags:
- ttime
---

I've found myself working on TTime, the Technion Timetable Scheduler, quite a
bit lately. Lots of cool stuff went in:

* Boaz Goldstein's TCal, a Cairo-based schedule renderer (could you believe the
  old version used MozEmbed?)
* Sports courses are now correctly parsed
* Ability to select specific lectures and groups for the automated scheduler
* A manual scheduler - given an existing schedule, you can ask to show all
  alternatives at once, and hand-pick them. Some people
  ([Tom](http://iiafw.com), for example) prefer this.
* Just for kicks - interoperability with [Grandpa](http://udonkey.com)'s XML
  format

I've also cleaned up the packaging quite a bit - it can now be installed using
`setup.rb`, or the updated Debian package. I think it may soon be time to tag a
release :)

[Sources at Github](http://github.com/lutzky/ttime)
