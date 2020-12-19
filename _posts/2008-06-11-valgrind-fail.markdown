---
date: 2008-06-11 01:08:00
title: Valgrind Fail
tags:
- code
---

I neglected to post this here somehow, it's about a month old by now...

> Screenshot lost in the mist of time... shows a program segfaulting, and then working properly when run within valgrind.

The problem turned out to be an imprecise (false-positve) comparison operator
implemented for a class used as a hash key. God, I hate C++.
