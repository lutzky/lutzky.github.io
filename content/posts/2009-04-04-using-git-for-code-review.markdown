---
date: "2009-04-04T12:23:00Z"
tags:
- git
title: Using git for code review
---

At my workplace, I've recently been using git for code review purposes. I work
on code in my own git clone, and ask a peer to review it. It works somewhat
like this:

1. `master` branch is same code as currently in upstream.
2. Working to resolve issue #1234 pertaining to "Performance for gizmo", I work
   on a branch `1234-gizmo-performance`.
3. I mail a peer, John, with this information, as well as my repository
   location.
4. John adds my repository as a remote, lutzky. Then he branches `review1` (or
   `review2` if that is taken, and so on) at `lutzky/1234-gizmo-performance.`
5. John adds comments with nice big `FIXME` tags, which are highlighted in
   any decent editor. He commits this, the commit-message stating that it was
   code review.
6. John tags his final review commit (or, if he had no comments -
   `lutzky/1234-gizmo-performance`) with a `reviewed1` (or `reviewed2`, etc.)
   annotated tag. Since the annotated tag includes all the necessary
   information (who tagged, when, and what), the number doesn't really matter.
7. I merge `john/review1`, incorporate the changes (or reject them) and remove
   the comments. If no further review is necessary, I submit this - and once
   submitted, I merge this back into master.

It's a nice system. I wonder what other methods there are of doing this.
