---
date: "2010-09-04T09:54:00Z"
slug: setting-up-hebrew-android-fonts-on-your-avd-emulator
aliases: ["/2010/09/04/setting-up-hebrew-android-fonts-on-your-avd-emulator/"]
tags:
- android
title: Setting up Hebrew Android fonts on your AVD emulator
---

There are several good guides for installing [Gilad
Ben-Yossef](http://benyossef.com/)'s excellent Hebdroid fonts on physical
Android devices, but those don't really work with the Android SDK's emulator -
changes to the `system` directory aren't persistent. Here's how to get around
that:

First, a few downloads. You'll need:

<!-- markdownlint-disable MD013 -->

1. The android emulator (presumably you already have this, if not, you can get
   it at [developer.android.com](http://developer.android.com/))
2. The [hebdroid fonts](http://firstpost.org/wp-content/uploads/2009/02/hebdroid.zip)
3. [unyaffs](http://code.google.com/p/unyaffs/), which will extract the `system.img` file
4. [A snapshot of
   yaffs2](http://www.aleph1.co.uk/gitweb?p=yaffs2/.git;a=snapshot;h=69808485ec796bfa2b4806f91828281eccd0827b;sf=tgz),
   which will create our new `system.img` file. This is actually today's
   snapshot from the git repository, which worked for me. For later versions,
   take a look at [the git repository](http://www.yaffs.net/node/346).

Building `unyaffs` is simple enough, or you can use the prebuilt version from
the site. Building `mkyaffs2image` is also quite easy - just untar the
snapshot, and run `make` in the `utils` directory. Put both of these utilities
somewhere in your `$PATH` for convenience.

Now we can get to work. First, locate your `system.img` file. It should be
within your Android SDK directory, under `platforms/android-3/images` (or
whatever version you're emulating). We'll extract that - create a temporary
directory, say `/tmp/system.img.hebdroid`, and `cd` to it. Then run:

```plaintext
unyaffs /path/to/system.img
```

The whole `/system` filesystem should be extracted. Now extract the `ttf` files
from `hebdroid.zip` into the fonts directory, replacing the original font
files. To pack everything back up, run:

```plaintext
mkyaffs2image /tmp/system.img.hebdroid system.img.hebdroid
```

Now, I recommend putting renaming your original `system.img` to
`system.img.orig`, and using symlinking `system.img.hebdroid` as your new
`system.img` (the emulator does indeed follow symlinks), but you can basically
do whatever you like. You may have to recreate your AVD, but everything should
work. Happy hacking!
