---
date: "2015-05-30T00:00:00Z"
summary:
  When I helped a non-programmer friend with some code for psychology research,
  and how we avoided using Matlab.
tags:
  - git
  - code
title: Seaplane - Github with a non-programmer
---

## The Faculty Programmer

Sharon, a close friend of mine, has been studying psychology for the past few years. At some point she needed to run an experiment in the field of perception. While the exact form of the experiment was pending professor vetting, she did know that the experiment will take place with a user sitting in front of a desktop computer, responding to various stimuli, often with the reaction time being recorded. Seeing as programming is not in her faculty's curriculum (a mistake, in my opinion), the students are provided with a faculty programmer. Dozens of students would contact this jaded craftsman, describe what they need, wait patiently, and then - as it happens in the world of software - receive something almost, but not quite, entirely unlike what they asked for.

I was all too happy to help (and owe Sharon an insurmountable number of favors to start with), but had nothing to start with at the time. The weeks and months passed, I was deep into my move and training at my new job[1], and happily suggesting (using my limited understanding of psychology) experiments. When the final proposal was authorized, the timing was inconvenient - I was going on a business trip to California the next day, putting a 10 hour time difference between Sharon and myself.

No matter. The experiment was fairly well-defined before I left - a word out of three word-sets, designated as "up", "down" and "neutral", was to flash in the middle of the screen, and then a circle would appear at the top or bottom. The user had to react to this circle as quickly as possible, and the idea was to test whether or not a word from the "up" category (such as "sky" or "cloud") would correlate with better reaction time when the circle appeared at the top, and vice versa. There were some other details such as "catch trials" when no circle would show up at all, but it sounded fairly simple. (Keep reading for a demo!)

## Getting started

My experience had me worried, as no software project is ever as simple as it originally seems. Sharon and I agreed that, while this seems completely reasonable and quite thought-out, we would work in an iterative fashion, and have regular video-chats on what should be done next. Also, to simplify things, I asked to create the software as a web page intended for use on Chrome, rather than Matlab as suggested by her faculty programmer (who seemed convinced, for whatever reason, that Matlab could give better timing precision - this turned out to be false). She agreed, and within a few hours on a plane, I had a basic draft working.

I emailed Sharon a copy of the draft; it was split into a simple `index.html` file, a `style.css` file, a `seaplane.js` code file, and a `config.js` code file. That last split was deliberate: Sharon, who has no experience in coding (and even claims to be a technophobe), could modify clearly defined configuration (including the sets of words and tuned delays) with no anxiety of "messing up" the more complex code. Soon enough, timezones flipped by, and Sharon was happy enough with the result to respond with a modified `config.js` file, and a list of changes she wanted - mostly present in the original requirements, but some which could only be understood while trying out the first draft. Naturally, some of the changes would require the syntax of `config.js` itself to change, and Sharon had more data to add to it. To avoid `seaplane7-final-really.zip` email attachments flying back and forth, version control would be required. Using Github would facilitate this, and also allow us to use its _Issues_ mechanism for tracking remaining work.

It took a few minutes over the phone to explain the basic concept of version control to Sharon, as well as how to create a Github account, modify files using the web-based interface, report and comment on issues. While I did mention Github for Windows as an option, I didn't pressure Sharon into using it, especially as I wasn't familiar enough with it myself.

Over 10 days and 48 commits (27 mine, 20 Sharon's) we got the code working well enough to run the experiment. There were a few reported bugs, but nothing substantial that skewed the results, as far as we can tell. You're welcome to see a [Demo of Seaplane](https://lutzky.github.io/seaplane), as well as browse the [Seaplane source code](https://github.com/lutzky/seaplane). If you can read Hebrew, you can also read [Sharon's paper](seaplane_paper.pdf).

## What worked

- Issues worked quite well for tracking the work; Sharon and I found them more useful than emails for keeping state.
- Being a fully client-side web application, seaplane was (and still is) trivially hosted by Github Pages. This made deployment of new versions as easy as hitting F5.
- For changes that could be previewed in chrome using developer tools, Sharon got instant feedback on her changes without needing to commit anything.
- Sharon made 4 commits to change `config.js`, modifying the word sets according to discussions with her supervisor. Sharon also made 11 commits to change `style.css`, 2 commits to change `index.html`, and even 3 to change `seaplane.js`.

## What didn't work

- Github's UI for submitting changes online has a default value for the commit message, and no recommendations against using it. As a result, there are 8 commits called "Update `style.css`".
- Sharon didn't have a working copy on her own machine, and not all changes could be easily previewed in chrome. As a result, there were some back-and-forth commits by Sharon and myself which weren't necessary. (I could've avoided this by providing appropriate "refresh" functionality in the app)
- The format I chose for the word list made right-to-left issues rear their ugly head in the editor.

All in all, the project went swimmingly. Using progamming-oriented version control software to collaborate with non-programmers may be less crazy than you think. I highly recommend giving it a try.

<hr />

[1] Oh yeah, I'm a Site Reliability Engineer at Google Ireland now, which is too awesome to detail in this footnote.
