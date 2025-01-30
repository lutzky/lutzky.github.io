---
title: "zsnapfree"
date: 2024-08-23
slug: zsnapfree
tags: ["software"]

featuredImagePreview: /posts/zsnapfree/screenshot.svg
---

Copy-on-write makes snapshots fast and accessible, but deleting them to
reclaim disk space can be a bit confusing. Let's have a quick primer on how
those work, and look at a small utility to help reason about it.

[zsnapfree](https://github.com/lutzky/zsnapfree) is a TUI for showing how much
space can be reclaimed by freeing zfs snapshots. It is a TUI wrapper over the
standard zfs tool.

If you just want to see zsnapfree in action, skip to [the screencast](#the-good-stuff).

## What are COW snapshots? 🐮

We all have little accidents with our files. Although the "Recycle bin" protects
you against accidentally *deleting* files, most filesystems don't protect
against accidentally *modifying* them. To change files back, you want a
filesystems with *snapshots*.

A snapshot is extremely fast to make, and lets you access the contents of the
file as it was when the snapshot was taken. In ZFS, with `zfs-auto-snapshot`
installed, the experience might look like this:

* A ZFS filesystem called `/tank/videos` exists.
* A file `/tank/videos/renders/my_video.mp4` exists, but I accidentally
  overwrite it.
* The file has existed for a while, so `zfs-auto-snapshot` has already created
  a snapshot of the good version at 14:17; specifically, it's called `zfs-auto-snap_hourly-2024-08-20-1417`.
* The good version is therefore available at (takes a breath)
  `/tank/videos/.zfs/snapshot/zfs-auto-snap_hourly-2024-08-20-1417/renders/my_video.mp4`.

We'll get back to those long snapshot names later. For now, it's worth sketching
out how this works.

The actual ZFS implementation is more complex, but roughly speaking, you can
imagine that the `videos` "current-state" is represented by a table that
includes rows describing what 128KB blocks make up each file. If our file
`renders/my_video.mp4` is 128MB, it will be made up of 1024 blocks, and the
table might have a section like this:

* File `renders/my_video` is represented by virtual blocks 1000 through 2023.
* Virtual block 1000 is in physical location 5001
* Virtual block 1001 is in physical location 6713
* ...

To create a snapshot, we only need to duplicate the information above, which is
roughly 8KB, so this can be done quickly and for very little extra space.
However, what happens when the data changes? Snapshots should remain immutable
even if the "current-state" changes.

Suppose for instance we change the very first block in the file - virtual block
1000. What happens now is the titular "copy-on-write" - the block which needs to
be rewritten will first be copied. Physical location 5001 would be duplicated to
a new location, say 7001, and this version of the block will be modified. The
current-state table would be updated to say that virtual block 1000 is in
physical location 7001 (but the snapshot would still have it listed as physical
location 5001).

Importantly, physical location 5001 is still in use, and cannot be freed. There
would likely be a table keeping reference counts for each physical location;
after the last snapshot referencing it would be deleted, this space can be
reclaimed.

## Accidentally storing big files

Suppose you accidentally store `useless_data.zip`, a 100GB file, in a filesystem
that takes snapshots. You find yourself running out of space, and decide to
delete that file... but no space is recovered. The reason is that snapshots
still hold this data, and you would need to delete all of those snapshots in
order to reclaim it.

The question is... which ones? Although you can run `zfs list -t snapshot -o
space`, the `USED` column there only counts space used by files which are
*unique to that snapshot*. That is, if another snapshot has been created (e.g.
by `zfs-auto-snapshot`), the `USED` column will count that file as zero.

Fortunately, ZFS has a great utility for previewing this. If we believe that the
file was created just before `snapshot1`, and deleted just after `snapshot3`,
then we can do this:

```shell
$ zfs destroy -nv tank/video@snapshot1,snapshot2,snapshot3
would destroy tank/video@snapshot1
would destroy tank/video@snapshot2
would destroy tank/video@snapshot3
would reclaim 100GB
```

This command actually does nothing (`-n`) except show information. Critically,
running it with just one or two of the snapshots would reclaim 0GB, so this is
great for harmless reasoning about what snapshots we'd need to sacrifice to
reclaim space. There's even a handy `%` "range" operator, so we could rewrite
the above as `tank/videos@snapshot1%snapshot3`.

## Dealing with long snapshot names {#the-good-stuff}

The unrealistic thing about the previous example is the short and convenient
snapshot names. `zfs-auto-snapshot` is great, but the snapshot names are more
like `zfs-auto-snap_hourly-2024-08-20-1417`. This makes trying different
snapshot selections cumbersome, and prompted me to write my very first TUI app
in Rust. It's a simple wrapper around the `zfs` command, and, well, a video is
worth several words:

{{< asciinema key="zsnapfree" >}}

When selecting snapshots, the tool runs (after a short delay) `zfs destroy -n`
to show how much space would be reclaimed. On exit, it shows the appropriate
commandline to check its findings and, if removing `-n`, actually perform the
deletion. Hopefully this is of some use for ZFS users, and I would love any
patches to add support for other filesystems that have snapshot support!
