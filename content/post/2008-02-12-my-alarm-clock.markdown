---
date: "2008-02-12T23:37:00Z"
tags:
- linux
title: My alarm clock
---

YNet was running a story on how to use your computer as an alarm clock. Here's
what I do, for our commandline junkies :)

Here's `~/bin/run_alarm.sh`:

```bash
#!/bin/bash

find ~/music/ -name '*.mp3' -print0 | xargs -0 mplayer -shuffle &

MAXVOL=31
TIME=900

for (( i = 0; i <= $MAXVOL; i++ )); do
        amixer set Master $i > /dev/null;
        sleep `echo $TIME / $MAXVOL | bc -l`
done
```

This basically plays all of my MP3 files, in random order. The `-print0` and `-0`
arguments make it a null-terminated list, as some (most) files have spaces in
their names. This process is backgrounded, and the script proceeds to gradually
sweep the volume from 0 to the maximum, for a more gentle wakeup :)

This script is basically intended for use with `at`. I made a little wrapper
around it for my comfort:

```bash
#!/bin/bash

if [ -z "$1" ]; then
        echo "Usage: $0 [time]";
        exit 1;
fi

echo /home/ohad/bin/run_alarm.sh | at $1
```
