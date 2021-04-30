---
date: "2014-01-05T00:00:00Z"
excerpt: Distinguishing <code>EPERM</code> vs <code>EACCESS</code>, and how that helps
  debug file manipulation scripts.
tags:
- code
- show downloading
title: Weird permission issues with tvnamer
---

My show downloading stack lives on. I'm curious as to which will happen first: NetFlix hits Israel, or I switch over to Sick Beard.

At any rate, nowadays I use `flexget`, `transmission`, `tvnamer` and `xbmc`, held together with some bash scripts. On debian- and ubuntu-based systems, the `transmission` daemon runs as a separate user (`debian-transmission`), so this requires a bit of care with file and group ownership. After rebuilding my system, I couldn't get `tvnamer` to work right for some reason, no matter how careful I was. I'd keep getting this error:

```text
Loading config: config.json
####################
# Starting tvnamer
# Found 1 episode
####################
# Processing file: Sherlock.S03E01.mkv
# Detected series: Sherlock (season: 3, episode: 1)
####################
Old filename: Sherlock.3x01.The.Empty.Hearse.720p.HDTV.x264-FoV.mkv
New filename: Sherlock - [03x01] - The Empty Hearse.mkv
New path: /home/debian-transmission/inbox/Sherlock - [03x01] - The Empty Hearse.mkv
Creating directory /home/debian-transmission/inbox
rename Sherlock.3x01.The.Empty.Hearse.720p.HDTV.x264-FoV.mkv to /home/debian-transmission/inbox/Sherlock - [03x01] - The Empty Hearse.mkv
OSError(1, 'Operation not permitted')
New path: /media/Store/shows/Sherlock/Season 3/Sherlock.3x01.The.Empty.Hearse.720p.HDTV.x264-FoV.mkv
Creating directory /media/Store/Shows/Sherlock/Season 3
OSError(2, 'No such file or directory')
```

For a few weeks I'd double-check the permissions, fail to understand what was going on, groan and copy the files manually. The new Sherlock episode had me in a bit of a more investigative mood.

This turns out to be an exercise in confusing OS logic and logging. It *looks* like the rename operation failed, and somehow the directory creation failed as well. Neither is the case. A hint can be found in the precise error after the rename: "1 - Operation not permitted" (that's `EPERM`). If that seems a bit off, that's because it is: When renames fail because of inadequate permissions, they return `EACCES` "13 - Permission denied". So what's going on?

It turns out that after renaming, `tvnamer` tries to preserve the access and modification times of renamed files. A noble cause, but it turns out that Linux won't allow this unless you are the *owner* of the file - even if you do have write permissions. Therefore, this fails, which causes `tvnamer` to believe the rename failed - although it hasn't. Afterwards, the directory is created (this succeeds), but since `tvnamer` tries to copy using the *old* filename (thinking the rename failed), we get an `ENOENT` "2 - No such file or directory" error about the *source* of the copy operation.

The fix can be found [in this pull request](https://github.com/dbr/tvnamer/pull/89). Happy bug hunting!
