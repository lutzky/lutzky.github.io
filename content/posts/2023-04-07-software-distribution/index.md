---
title: "Getting your code to your friends"
subtitle: "Reminiscing about software distribution"
date: 2023-04-07T21:41:24Z
lastmod: 2023-04-07T21:41:24Z
draft: true

tags: ["software"]
---

TODO some description here

<!--more-->

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

{{< image src="QBasic_Opening_Screen.png" caption="QBasic's opening screen (Source: Wikipedia)" >}}

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
generate an EXE file complete with an icon. Efforts included taking something
called the "PIF Editor", which creates shortcuts to files and ostensibly adds
icons to them... and replacing one of the system `EXE` files with it, in case
the filename was "magical". The real magic was young me learning the valuable
lesson that I should've made a backup of this file before replacing it.

## Visual Basic

By the late 90s, Windows 9x came around along with Microsoft Office, which had a
wonderful capability: [Visual Basic for Applications][vba]. this gave me my
first experience writing actual GUI applications, strangely embedded within an
Excel spreadsheet. Most memorably, Pokémon was a huge deal at the time, and I
had created "APCO - A Pokémon Card Organizer" - a trivial deck building app.

[vba]: https://en.wikipedia.org/wiki/Visual_Basic_for_Applications

{{< admonition >}}

On April 1st, 1997, the very first episode of the Pokémon anime was shown on
Israel, on channel 6; I was the official "hero of the day" guest, as a Pokémon
expert. I got to this position by nitpicking on some "kids' portal" website that
their Pokémon page contained inaccuracies, which landed me a job as their
Pokémon card strategy reviewer; I was 11, so they paid me in Pokémon cards.

For the anime premiere I was interviewed by Dana Dvorin; I have sadly been
unable to find any footage of this hialriously awkward interview.

{{< /admonition >}}

Once again, I wanted to distribute this software - perhaps using this magical
thing I now had access to called *The Internet*. And, once again, sending an
excel `XLS` file around with a big "click me to start the actual program button"
seemed, well, janky. Amazingly, a friend had a copy of "really real Visual
Basic" (the coveted *compiler* I had heard of), and was able to convert my janky
app-in-`XLS` to a proper shiny `EXE` file. Slight caveat - there was a runtime
library that had to be distributed alongside it, or it wouldn't work.

This got me looking at *installers*. All of the "serious" software was proudly
using InstallShield (this was before these newfangled `.MSI` files - even the
installer was a shiny `.EXE`!), but looking at a trial version left me
scratching my head at how things should be organized. Finally, a self-extracting
RAR file (yay shareware WinRAR) did the trick. I vaguely recall successfuly
uploading the finished product to some download site of the era, probably
Tucows.

{{< image src="installshield.png" caption="If your software didn't come this way in the 90s, was it even real software?" >}}
