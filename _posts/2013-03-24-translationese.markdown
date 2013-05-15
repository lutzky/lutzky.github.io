---
date: 2013-03-24 00:51:15
layout: post
title: Translationese
tags:
- natural language processing
- coding
- python
---

As part of my M.Sc. studies, I've recently completed a small laboratory project
in natural language processing. I've learned quite a bit from it, and had a
chance to use a few of my favorite technologies.

The project was coded in Python, which is _not_ my favorite programming
language - Ruby is. However, since Python is more popular at my workplace, and
seems to have a richer ecosystem around it (sometimes, at any rate), I've grown
to love it almost as much over the years. It's quick, easy, and has fantastic
libraries; specifically, for this project, we made heavy use of the [Natural
Language Toolkit](http://nltk.org). We used Git for source control and Github
for hosting, Travis for continuous integration, and ReadTheDocs for
documentation. All of these culminate in the project being handed in as a
single link: http://github.com/lutzky/translationese.

The translationese project is a re-implementation of the concepts presented in
"On The Features Of Translationese", an article describing an attempt to
automatically distinguish between texts written in English originally, and
texts translated to English from a different language. Since this turned to be
an easy problem, the focus was to determine what specific _features_ of a given
text are better at distinguishing between the two categories.

Why reproduce results from an existing article? Well, beyond academic points,
we wanted to provide well-documented, easily-extensible, _tested_ code. The
article was not always clear on specific definitions of various features;
Python code makes these completely explicit, in a relatively readable way (for
code, at any rate).

To keep code quality high, we used test-driven development: each feature was
coded only after a (failing) unit test for it was written. This helped keep the
code modular, and made refactoring (which happened quite a bit) easy and safe.
The resulting design proved to be quite flexible, as I will shortly explain.

[SVM](http://en.wikipedia.org/wiki/Support_vector_machine) is a form of
_machine learning_. Simply put, it's a method of teaching a machine to
distinguish between two categories of "points" (in our case, "translated" and
"original"). The SVM is given two such sets, and tries to draw a "line" (or,
generally, a hyperplane) separating them. Afterwards, it should be able to
classify new points (without being told which set they belong to) by which side
of the line they are. The following image (Wikipedia) shows a simple,
two-dimensional case (the red line properly distinguishing the two sets):

![](http://upload.wikimedia.org/wikipedia/commons/b/b5/Svm_separating_hyperplanes_%28SVG%29.svg){: style="max-width:350px"}

For our case, each _"property"_ took a block of text, and translated it to an
_n_-dimensional point. For some properties, the dimension was quite extreme.
For example, the property of character trigrams gives each coordinate the value
of "how many times does each permutation of three consecutive letters appear in
the text". There are 17,576 such permutations, so each text became a point in a
17,576-dimensional space. These points were fed into an SVM algorithm
implemented in [Weka](http://www.cs.waikato.ac.nz/ml/weka).

During the final presentation of the project, we explained that the
particularly high-dimensionality properties proved to be too much for Weka (it
would use up all available RAM), so smaller sample sizes were used for those.
However, we were told that using sparse vector representation as Weka's input
could allow it to be more efficient. Fortunately, our design proved to be
robust enough that I could implement (and test) the change during the
presentation ([1278645][hack]).  Indeed, we now had no problems with the
high-dimensionality properties, and repeated our runs, updating the
documentation (after we were given our grade...)

There's a somewhat eerie aspect to this project. Having used SVM, I have no
idea how it works. While I know exactly how my Python code works, and exactly
what the SVM algorithm does, I still don't know how to tell a translated text
from one written in English originally. Even looking at the SVM output, which
details exactly what the resulting classifier does, the data is the result of
analyzing thousands of texts, and something of an "intuition" the classifier
has generated from its "experience"; certainly not a formal algorithm that I
can read and understand. While I could read it and painstakingly apply it
manually to text, I'd be blindly following a program which I do not understand,
much like a Rubik's Cube novice following an algorithm, not (yet) understanding
why it solves the cube, and being quite surprised when it does. With the high
complexity of the resulting classifier (for example - for every three letters,
look up its index in a 17,576-entry list and increment it by a factor), I'd
have no chance of ever understanding how it works. In essence, I've written
code to have my computer learn how to do something, but it cannot practically
teach me what it has learned.

[hack]: https://github.com/lutzky/translationese/commit/12786459ef41d64963fd19433ba86dd71acc0e92
