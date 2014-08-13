---
layout: post
title: "Lessons learned"
---

After 6 years with my previous employer, as a DevOps engineer and DevOps team leader, I've learned two important lessons. I wanted to get these in here before I start my new position (...as an SRE in Google Dublin, which I am very excited about!), as it's always fun to look back after a few years and see if what I wrote is still relevant.

Keep it tidy
------------

Working in a tidy manner is incredibly important. Tidy code is more important than fast code. It's even more important than correct code! Tidy code is obvious about what it does, and the incorrectness will be apparent to anyone who reads it. However, correct messy code will be misleading about what it does, and what subtleties had to be dealt with in order for it to be correct. This will cause long hours and hair loss when refactoring or when tending to changing requirements.

*Requirements change.* A good team leader will be able to predict how they'll change, and direct his team around that. Incorrect predictions are inevitable and costly, but so is a complete lack of change prediction.

Operations need to be just as tidy as code, if not tidier. *Operations performed manually will inevitably be performed wrong, usually by the one person you're sure can't possibly get it wrong.* As such, operations need to be as idiot-resistant as possible (nothing is completely idiot-proof). "Run this job in Jenkins, the rest is a script" is a good place to be, but you should make sure it's really hard to run the wrong job, or get any parameters harmfully wrong.

Any knowledge contained within one brain reduces your [bus factor](http://en.wikipedia.org/wiki/Bus_factor) to 1. Use pair programming (or pair-ops) to increase your bus factor. Whenever possible, let someone from your team tackle a task he has no idea how to perform, but make sure both you and someone knowledgeable are available (and willing) to answer questions. However, containing knowledge within brains is fleeting - even with a high bus-factor, some areas will be left untouched for years, and subsequently re-touched when nobody remembers anything about them. When this happens, you'll be much happier to find out your predecessor (or past-you) has left solid documentation and completely obvious code.

Don't write it yourself
-----------------------

This is a special case of "keep it tidy". Writing your own code should be your last resort: Someone else has already written, tested, fixed, debugged, documented, rewritten, and perfected a piece of code that does exactly what you need. They did this with the help of far better coders than you can afford and a QA team comprised of countless relentlessly nitpicking users. *Your problem is not as unique as you think.*

You will ignore this advice. You'll write your own "super efficient" database/JSON parser combo, and guard it as a trade/military secret. And it'll even work for the first few years, and perform fantastically. But as requirements change (*requirements change!*), you'll suddenly find out that you can't push new features and bugfixes out as fast as your competition. This happens because your competition is using a widely-adopted database, and a (separate) widely-adopted JSON parser. These are both open-source, and you will see that some kid in a basement has stumbled onto your clever optimizations and suggested them - these have been merged in. And while you're stuck debugging your code, with its sparse unit tests and misleading function names, your competition is looking up known issues and workarounds on Stack Overflow.

Hiding within this advice is the one worse thing you can do than writing it yourself: Using unpopular closed-source software (especially if it's hard/impossible to search for in Google). This has all the detriments of writing code yourself, with the added hell of being unable to read or modify the code yourself when something goes wrong.

This advice is clearly quite extreme and is intended to be cautionary (and you will therefore, as mentioned, ignore it). You probably do have some business logic to implement. You probably do need to write glue code in order to connect your proprietary code with some external provider. You might be dealing with insane, Google-scale problems and have found (after checking!) that all existing solutions don't meet your performance/capacity criteria. But this is no reason to implement your own version of `ping`. Or `rsync`. Or `cron`.

Afterword
---------

That's my 2 cents on how to do DevOps (for a rather narrow definition of DevOps). They're the instructions I left my team. I wonder if they'll stand the test of time.
