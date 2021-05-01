---
date: "2020-11-07T00:00:00Z"
summary:  Messing with old video from tapes, simple audio corrections, splitting and
  organizing for the family's benefit.
title: Editing old family videos
---

In the 90s, my family (along with much of the rest of the world) filmed a lot of home videos. At some point we converted them to what we believed to be DVD for preservation and ease-of-access, but this was actually VCD (which has somewhat worse compatibility), burned on CD-R (which degrades faster than you might think), and optical media has pretty much become extinct as well. In a family visit in 2018 I found the old stash of original video cassettes, flew them with me from Israel to Ireland, and got a local shop called DVD Centre to re-rip them - these guys provide the great service of uploading directly to Dropbox.

I've been spending some sporadic time on weekends rewatching all of these, cataloguing them into what Googlers call a "one-pager" - a long document that may span many pages if printed out, but can be loaded by normal software with simple search functionality (a Google Doc, in my case). This is great for searching by name or event to more easily locate the right video. The tapes are still quite long though - usually 1-2 hours, and can be logically split into smaller segments. They also often have audio issues, such as audio only coming out of one side or having very inconsistent volume.

For the last few weekends (2020 is a weird year that gives me more time to do this kind of thing), I've been working my way through the videos, correcting audio and splitting them into smaller logical chunks. I've uploaded them to Google Drive and shared with my family, who can now easily access them right from their phones from a different continent. It's been bringing back many memories and feels like a worth preservation effort for these memories.

Here's my workflow, in case it's useful for anyone else:

## Audio corrections

First, split the audio stream into a separate file so you can modify it with the software of your choice. I use `ffmpeg` for this. The `ffprobe` program lets me determine the current audio type, which is `aac` in my case, so I do:

```
ffmpeg -i ORIGINAL_VIDEO.mov -vn -acodec copy output-audio.aac
```

Now I open `output-audio.aac` in Audacity, and perform:

1. If only one audio stream is available, downmix stereo to mono so it at least comes out of both speakers. (Tracks -> Mix -> Mix Stereo down to Mono)
2. Normalize, to get the baseline audio levels comfortable (Effects -> Normalize)
3. As a personal choice, to get the audio levels consistent, I apply extremely aggressive compression - Effects -> Compressor, lowest possible threshold (-60 dB here), maximal possible ratio (10:1), attack time of 0.2 seconds and release time of 1.0 seconds. This destroys any dynamic range, but the forced consistency of audio levels helped me pick up what people are saying - they were being recorded from various distances at varying noise levels.

There's a lot more processing you can do here (graphic equalization may be a good idea), but the ones I described worked well as "catch-all" fixes that I could apply to all audio without thinking about it too much.

Export this in the same audio format (again, aac in my case - I'd use `ffprobe` on the original to see the approximate bitrate, but it's not necessary to match it precisely), and recombine like so:

```
ffmpeg -i ORIGINAL_VIDEO.mov -i output-audio-fixed.aac -c:v copy -map 0:v:0 -map 1:a:0 ORIGINAL_VIDEO_sound_fixed.mov
```

This method was both faster and more flexible than using the video editors I have at my disposable.

## Splitting video

At this point, I watch the video through, writing down key points of what's going on with approximate time-codes. It helps to do 3-4 different tapes of this before moving forward, as it gives you a feel for what the "logical separation" to smaller chunks is. I usually define those chunks as "different set of consecutive days" (usually just one), but it helps to have all the timecodes available in text so you don't have to re-watch. I recommend using a player that supports faster-than-realtime viewing, such as VLC (speed up, stop on "hey what was that", rewind, watch at regular speed). This is the most time-consuming part.

After this, I decide on the section structure, and need to determine the precise frames where I want to split. Since most video players aren't designed to "go back one frame", I actually open the video in a video editor (the free HitFilm Express, in my case). I start with the rough time-codes from the previous step, and step frame-by-frame back-and-forth until I find the first and last usable frames of a section. I write these to a `points.txt` file with the following syntax:

```
00:00:00:00-00:15:48:13
00:15:50:17-00:40:14:01
...
```

Here, the format is `Hour:Minute:Second:Frame` - in my case the video is 25 FPS, so `Frame` is between `00` and `24`.

Next, I want to split the video using ffmpeg - this can be done without recoding, which is much faster (on my laptop - a few seconds per section, as opposed to multiple minutes) and doesn't degrade quality. For the timecodes above, the correct split commands are:

```
ffmpeg -ss 0:00:00.000 -i audio_corrected.mov -to 0:15:48.520 -c copy segment_1.mov
ffmpeg -ss 0:15:50.680 -i audio_corrected.mov -to 0:24:23.360 -c copy segment_2.mov
```

These are annoying to create manually, because:

1. The timecode for ffmpeg is given in milliseconds, so 13 frames in 25fps becomes 520 milliseconds.
2. The `-to` offset is from the section's *start* (so it's more of a `-length`), and subtraction is hard.

So, of course, I wrote [some code](https://github.com/lutzky/splitpoints) to do this for me. It takes a `points.txt` as described above, and outputs the appropriate series of commands.

All that's left to do is to let the commands run, upload the videos, and wait for Google Drive's video-rendering to catch up.

Good luck on your video preservation adventure!
