---
date: "2014-08-15T00:00:00Z"
excerpt: Using <code>.gitignore</code> to exclude build artifacts from your repository.
tags:
- git-while-you-sit
- git
title: Git While You Sit 2 - .gitignore
---

This is part of the "Git While You Sit" series, a play on Google's [Testing on the Toilet](http://googletesting.blogspot.co.il/2007/01/introducing-testing-on-toilet.html). It's intended to fit on a printed page. Currently Chrome doesn't seem to correctly print columns, but Firefox does.
{: .no-print }

Your repository has files which are generated as part of your build process or as part of running your software, which you don't want in source control. They keep showing up in `git status`. What to do?

You can create a file called `.gitignore` - note that the filename starts with a `.`, which is standard for configuration files in Unix and causes them to be hidden from normal listing. Each `.gitignore` file affects the current directory and its subdirectories - you can have multiple `.gitignore` files to create more specific rules for subdirectories.

*Note:* `.gitignore` can only be used for files which shouldn't be in source code *at all* (those show up as "Untracked files". *Modified* files can't be ignored in this way. If you really want to, you can force git to ignore modifications with this command:

```console
$ git update-index --assume-unchanged FILE
```

However, this is usually a bad idea and indicates you need to refactor your file handling - split files which get modified locally from files which contain information which should be source-controlled.

Here is an annotated excerpt from a `.gitignore` file:

```text
# Extensions of compiled files
*.a
*.so
*.o
# ...

# Files generated by build system
build.ninja
.ninja_deps

# Ignore bin/ and obj/, as they contain
# compiled files. This is ignored
# recursively within the repository.
bin/
obj/

# ...except ("!") for the scripts, which
# are in the "scripts" dir in the same
# one as this .gitignore file (hence the
# leading "/")
!/scripts/bin
```

Addendum: A reader has mentioned [gitignore.io](http://gitignore.io), which auto-generates useful `.gitignore` files.