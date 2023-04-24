---
date: "2008-06-11T01:08:00Z"
slug: valgrind-fail
aliases: ["/2008/06/11/valgrind-fail/"]
tags:
- software
title: Valgrind Fail
---

I neglected to post this here somehow, it's about a month old by now...

> Screenshot lost in the mist of time... shows a program segfaulting, and then working properly when run within valgrind.

The problem turned out to be an imprecise (false-positve) comparison operator
implemented for a class used as a hash key. God, I hate C++.
