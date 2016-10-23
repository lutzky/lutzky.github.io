---
layout: post
title: "Test-driven procrastination"
tags: [code, testing]
---

A conversation with a friend reminded me that, in fact, I've been doing
test-driven development long before I knew it was called that. Back in
Introduction to Systems Programming (a second-semester course revolving around
abstract data types in C, introduction to C++, and hands-on experience building
multi-module C programs), most homework exercises looked something along these
lines: Write a program managing a store inventory, with a command-line client
conforming to a given set of specifications. For an input file looking like
this:

```text
addcategory Fruit
addproduct Fruit Banana 2.30
addproduct Fruit Tomato 1.20
addproduct Fruit Apple 1.50
addproduct Fruit Apple 1.60
list Fruit
```

The output file would be expected to look like this:

```text
OK
OK
OK
OK
ERROR Duplicate fruit Apple
Fruit
-----
Apple  1.50
Banana 2.30
Tomato 1.20
```

Of course, error messages, sorting and spacing for the output would be part of
the spec. That provided an effective way of checking your program's
correctness: Run it on a given input, and compare its output - using `diff` - to
expected output. Some TAs even provided simple test files (input + expected output) for this exact method
(but not revealing the "real" test files which would they use while grading),
but the "serious" tests happened in the student-run "homework help" forum (ah,
phpbb...), where students would regularly place gargantuan test files to
compare your program against (these were very helpful in finding memory
handling errors).

For an advanced technique, I wrote a "reference" implementation in Python (this
is much shorter than the C version, and probably less bug-prone). I then
generated random input files, fed them into both programs, and whenever the
output would differ between the two - I'd found in a bug (in one of the
versions).

I recall a certain student festival, a friend ran up to me, and exclaimed: "I'm
totally wasted. I've had no sleep for the past two days, but I've finally
finished the exercise. `diff` \[outputs\] 0 \[lines of difference\]!  Whoo!" He
ran off at this point.

What does all of this have to do with test-driven development? It became
"known" that it's better to start the exercises later, so that early-bird
students will have test data up on the forum before you start. Then, just code
until the tests pass. Ah, the excuses we students come up with for
procrastination...

I've been striving to do test-driven development ever since, with the help of
proper unit testing frameworks, and it's hard for me to think of having ever
coded without it. There are plenty of resources online explaining why
unit-testing is such a helpful idea... all I'm saying is that you might already
be testing your code, not realizing that a nice framework can help. But more on
that later...
