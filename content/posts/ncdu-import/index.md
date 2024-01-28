---
title: "ncdu-import"
date: 2024-01-28
slug: ncdu-import
tags: ["software"]
---

Figuring out what's taking up space is a well-known issue, with a variety of
great tools for it... if we're talking about files on a local hard drive.

<!--more-->

Tools like the textual [`ncdu`] and the graphical
[baobab] let you start with a
high-level summary, and dive into specific directories to find out what's taking
up all of the space.

[`ncdu`]: https://dev.yorhel.nl/ncdu
[baobab]: https://wiki.gnome.org/Apps/DiskUsageAnalyzer

{{< image src="ncdu-screenshot.png"
    caption="Screenshot of ncdu" >}}

However, sometimes what you have is on a cloud storage system, which is happy to
*bill* you for space your files take, but the UI doesn't make it super-easy to
figure out which directories take up that storage. For example, with Google
Cloud Storage, you *can* use `rclone ncdu`, but my modest backup bucket had it
consistently timing out. For this purpose, the recommended path appears to be
[Storage Inventory], which will provide you with a CSV listing of all of the
files in your bucket.  The apparent recommendation is to analyze it using a
custom-crafted BigQuery query, which is nowhere near as handy as `ncdu`.

[Storage Inventory]: https://cloud.google.com/storage/docs/insights/inventory-reports

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD013 -->
```text
$ cat inventory-reports_VERY_LONG_ID.csv | cut -f3,10 -d,
name,size
esphome/config/esphome-tester.yaml,5254
esphome/config/esphome-tester2.yaml,1049
meta/esphome/docker-compose.yml,308
misc_backed_up/ohad/3dprint/light_switch_covers/Part Studio 1 - Part 1.stl,1484
misc_backed_up/ohad/3dprint/light_switch_covers/Part Studio 1 - Part 2.stl,1033884
misc_backed_up/ohad/3dprint/light_switch_covers/Part Studio 1 - Part 3.stl,1591184
misc_backed_up/ohad/3dprint/light_switch_covers/light_switch_covers.gcode,919652
misc_backed_up/ohad/3dprint/light_switch_covers/old_too_small/Part Studio 1 - Part 2.stl,1033884
misc_backed_up/ohad/3dprint/light_switch_covers/old_too_small/Part Studio 1 - Part 3.stl,1603784
misc_backed_up/ohad/3dprint/light_switch_covers/old_too_small/light_switch_covers.ufp,142725
misc_backed_up/ohad/3dprint/light_switch_covers/old_too_small/light_switch_covers_gcode.ufp,627744
...
```
<!-- markdownlint-restore -->

Fortunately, `ncdu` has an import/export feature, for those slow scans. `ncdu -o
foo.json` will save such a report (slowly), and `ncdu -f foo.json` will display
it (quickly). So, how about if we cheat, and convert our CSV of
files-in-the-cloud to `ncdu`-compatible JSON?

That's where [`ncdu-import`] comes in.  Bring it a CSV file which has a "path"
column and a "size" column (tell it what the columns are), and it'll spit out a
JSON file loadable by `ncdu` for quick and convenient analysis. You can look at
the [testdata dir] to get a few examples of what it's doing.

[`ncdu-import`]: https://github.com/lutzky/ncdu-import
[testdata dir]: https://github.com/lutzky/ncdu-import/tree/main/testdata

{{< image src="ncdu-screenshot-with-import.png"
    caption="`ncdu` showing output `ncdu-import` on the sample CSV above" >}}
