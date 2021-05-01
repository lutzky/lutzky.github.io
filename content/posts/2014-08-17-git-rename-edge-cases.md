---
date: "2014-08-17T00:00:00Z"
summary:  |
  Sometimes, git does something unexpected while merging or rebasing. It might seem like git misunderstood a rename, but it's far more likely that git did the "right" thing after all.
tags:
- git-while-you-sit
- git
title: Git While You Sit 3 - "Rename" edge cases
---

This is part of the "Git While You Sit" series, a play on Google's [Testing on the Toilet](http://googletesting.blogspot.co.il/2007/01/introducing-testing-on-toilet.html). It's intended to fit on a printed page. Currently Chrome doesn't seem to correctly print columns, but Firefox does.
{: .no-print }

Sometimes, git does something unexpected while merging or rebasing. It might seem like git misunderstood a rename, but it's far more likely that git did the "right" thing after all. Here are a couple of examples I've seen recently.

First case
----------

When rebasing, conflicts might occur *before* renames:

```text
o---o---E---F---G (master)
     \
      A---B---RENAME---C (feature *)
```

When the current branch is *feature*, and running `git rebase master`, what happens is that the commits from `feature` will be `cherry-pick`ed onto `G` in order - `A`, `B`, `RENAME`, and `C`. If a conflict occurs in `B`, in a file that was later renamed (in `RENAME`), conflict resolution will have to happen *using the original name*. If there was a massive reworking, it might be simpler and more sensible to *merge* in this case.

Second case
-----------

It wasn't a rename, it was a copy.

```text
--o---E----F [MODIFY]----G (master)
   \                      \
    A---B [COPY]---C---D---M (feature *)
```

In this case, the user thought he renamed `dir1/file.xml` to `dir2/file.xml` in `B [COPY]`. Then, when he merged `master` into `feature`, he expected that the modifications in `file.xml` in `F [MODIFY]` would, as part of the merge in `M`, be applied to `dir2/file.xml`. This would indeed have happened if `B` had a move operation. However, it doesn't make sense for git to merge the changes from a *copy* of a file, so it didn't.

The fix here was to undo the merge:

```console
$ git reset --hard D
```

...and then edit the commit:

```console
$ git rebase -i A
```

...and set `B` to `edit` instead of `pick`. Amend the commit for `B` so that it doesn't just create `dir2/file.xml`, but also deletes `dir1/file.xml`. If it's indeed the same file (or has very similar contents), this will be automatically detected as a rename during `log` and `merge` operations.

It should be noted that git doesn't track renames (or copies) at all during commits. It only figures out that they happened retroactively when it's relevant (`log`, `merge`, `cherry-pick`, `diff`...), by comparing the contents. This is why those operations have options like `rename-threshold`, `find-renames`, `find-copies` and even `find-copies-harder`.
