---
title: "Getting your code to your friends"
subtitle: "Reminiscing about software distribution"
date: 2023-04-07T21:41:24Z
lastmod: 2023-04-07T21:41:24Z
draft: true

tags: ["software"]
---

## QBasic

In the early 90s, when I was about 8 years old, someone showed me that my
computer came with a piece of software called [QBasic][qbasic] - it came with
the MS-DOS operating system.  Although nobody in my family knew how to use it,
and this was long before I had access to the internet, it came with an
impressive set of examples as well as an interactive reference manual that I
recall as being very thorough. Having messed around with it and made a few
animations and utilities, I thought it would be cool to give copies to my
classmates to play around with; y'know, like a professional software developer would.

[qbasic]: https://en.wikipedia.org/wiki/QBasic

{{< image src="QBasic_Opening_Screen.png" caption="QBasic's opening screen" >}}

This presented an interesting problem. The software, as I wrote it, was a
collection of source code files - just text files with a `.BAS` extension. For
anyone to run those programs, they'd have to open QBasic themselves, use the
"File→Open" menu command, select my file, then use the "Run" menu to actually
run the program. And presumably figure out how to exit QBasic when they're done.
Now, for 90s 8-year-olds, typing out a command or two to open a game from DOS
was reasonable, and indeed, friends did figure this out, but it felt *super
janky*.

What I actually wanted to do was provide a self-contained program, one where you
simply enter its name and it starts up, like any other DOS program (or game!)
I'd seen. Ideally, it would have the coveted `.EXE` extension, as the term
"`EXE` file" seemed pretty much synonymous with "program". I'm not sure if I
figured it out at the time, but I could've probably included a `.BAT` (MS-DOS
Batch) file with the contents `QBASIC /RUN LUTZKY1.BAS`, maybe with some `@echo
off` or whatever was the right syntax for reducing janky output... but it felt
"off".

I had heard rumor of the "professional, expensive" bit of software I needed - a
*compiler*, which would perform the right magic to me a shiny, self-contained
`LUTZKY1.EXE`. But this sounded like an expensive thing to even ask my parents
for, never mind the fact I had no idea where one *buys software* (other than
games).

{{< admonition >}}

In 2023, I found out that this software was called [QuickBASIC][quickbasic]...
not confusing at all, surely the Q in QBasic didn't stand for "Quick" and they
weren't both abbreviated "QB".

[quickbasic]: https://en.wikipedia.org/wiki/QuickBASIC

{{< /admonition >}}

I vaguely remember messing around blindly with files on my computer, trying to
generate an EXE file complete with an icon. (Add note about PIF files)



<!--more-->
