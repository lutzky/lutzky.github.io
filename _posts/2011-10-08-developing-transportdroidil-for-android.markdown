---
date: 2011-10-08 19:43:00
layout: post
title: Developing TransportDroidIL for Android
tags:
- android
- TransportDroidIL
---

Here are a few words on developing [TransportDroidIL][tdil_market], a small
utility to query Israeli public transportation sites more easily using an
Android phone.

Source control is super important. Mistakes will be made, other coders will
want to join in, and experimental features will want to be in their own
branches. [Git](http://git-scm.com/) is awesome; it does source control
_right_, gives me powerful tools, and isn't a hassle to set up - even for a
small project like this. [Github](http://github.com/) is also awesome; it makes
collaboration with other coders - even just one, in my case - easy, organized,
and fun.

One of my favorite git features is _revert_. It allows you to automatically
inverse a previous change. Here's an example from TransportDroidIL:
[0e194de](https://github.com/lutzky/TransportDroidIL/commit/0e194de5b8f24f85a3b4931963a06743525dacf8).
This commit reverts a previous "cleanup" commit in the autocompletion code -
allegedly, I was keeping two copies of the autocompletion option list for no
reason: One as a `LinkedList<string>`, and one internal to the
AutoCompleteTextView which I can access via an `ArrayAdapter<string>`. Turns out
that my `LinkedList<string>` copy is necessary, because the `ArrayAdapter<string>`
always behaves as though it's empty, so it cannot truly be read from. Despite
having performed a few commits since that bad "fix", git was very helpful in
letting me revert that particular change, showing me the conflicts this
operation causes, and allowing me to fix them. The lesson is an important one:
Make small, manageable commits. Git is optimized for this, as commits are local
(no need to contact the server until a _push_).

Developing for Android makes a lot of sense when using Eclipse. I'm a VIM
junkie, and generally dislike IDEs. Eclipse is slow and heavy - but it gets the
job done, and it does it very well. It's a bit weird that a plugin is required
to manage color schemes - but it exists. It's **very** weird (and quite
annoying) that it doesn't remove end-of-line white-space, and doesn't have an
option to do this. This makes git complain. There _is_ an option to add
"clean-up" settings which are activated on every save, but this is far too
cumbersome and might change code I didn't intend to change (which becomes
confusing in the revision log). Still, the excellent debugging, JUnit and
logcat support are worth it.

Logcat is another awesome feature of Android. Every logged line has both a
"Tag" (usually defined per-class) and a severity. Logs can be filtered with a
different severity for each tag, and still - one can use the same logcat to
show messages from anything running on the Android device at the moment. It's
basically Syslog done better.

One last point is about Hebrew. This has been a problem with Android for quite
a while; for example, in a stock Android 2.3.3, numbers embedded in Hebrew
string appear backwards. Fixes exist, and are implemented in most Israeli ROMs,
especially the ones distributed by phone carriers - but they're different, and
sometimes don't work for all applications. This causes numbers to appear
backwards in TransportDroidIL, which in turn caused me to implement an
[ugly][uglyhack1] [hack][uglyhack2]. I hope the upcoming Ice Cream Sandwich
release fixes this.

[uglyhack1]: https://github.com/lutzky/TransportDroidIL/commit/713a9bd89547763776bb8a1c991ceb23bd6426c5
[uglyhack2]: https://github.com/lutzky/TransportDroidIL/commit/6ba21053a8e981882bd0b1f808f257979a2bf488

[tdil_market]: https://market.android.com/details?id=net.lutzky.transportdroidil
