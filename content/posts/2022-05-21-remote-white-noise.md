---
title: "Remote White Noise"
date: 2022-05-21T12:07:35Z
tags: ["software"]
---

<!-- markdownlint-disable MD013 -->

One young-child-parenting trick that has worked well for us is white noise. It might be because it emulates in-the-womb-noises, drowns out other noises, or gives baby something to fixate on - but it often does a great job of calming him to sleep. Nearly a year old now, he thankfully doesn't usually need it for night sleeps, but it's helpful for a "cranky-because-tired" nap or getting him to sleep for another half-hour when he decides to wake up very early.

There are quite a few ways to play white noise, and many cheap mobile battery-powered devices will do the trick just fine. However, I wanted a bit more control, at least for when we're at home:

- It'd be useful to turn on the noise remotely, as entering a cranky baby's room sometimes riles him up.
- It'd be useful to (gradually!) turn _off_ the noise remotely, especially as my wife doesn't like the sound and it can be made worse with a baby monitor.
- I'd like to customize the sound itself (we're actually going for more of a [pink][pink-noise]/[brown][brown-noise] noise)

[pink-noise]: https://www.youtube.com/watch?v=ZXtimhT-ff4
[brown-noise]: https://www.youtube.com/watch?v=RqzGzwTY-6w

After trying out several options, I went for using a Google Home Mini; we have several of those lying around (they used to come as free gifts with various purchases), the audio quality is reasonable, and it's compact and clean-looking. Although it does respond to a "play white noise" command, that plays [this 1-hour-long segment][1hr-noise], which is too short. Instead, I created a 10 hour version with customized parameters like so (mostly inspired [here][white-noise-askubuntu]):

```shell
sox -c1 -n result.ogg \
  synth 36000 brownnoise synth pinknoise \
  mix synth sine amod 0.1 90
ffmpeg -i result.ogg result.mp3
```

Why is the conversion to MP3 important? See [quirks](#quirks).

[1hr-noise]: http://www.gstatic.com/voice_delight/sounds/long/pink_noise.mp3
[white-noise-askubuntu]: https://askubuntu.com/questions/789465/generate-white-noise-to-calm-a-baby

The rest is a matter of hooking it up to [homeassistant][homeassistant]. The `media_player.play_media` service gets it to play just fine. To make it easy to toggle, I created an [input boolean][input-boolean] and automation to start or stop media when it changes. Because the google home can also be stopped directly, I added a second automation which sets the input boolean off when that happens.

[homeassistant]: https://www.home-assistant.io/
[input-boolean]: https://www.home-assistant.io/integrations/input_boolean/

## Main dashboard toggle

Having the white-noise-toggle on the main dashboard (an old chromebook in kiosk mode) is quite useful, especially when babysitters are involved. (There's also a physical button, driven by ESPHome, in the nursery - but that's not quite remote).

My wife had a great idea for styling this toggle - showing a picture of the baby awake when the white noise is off, and asleep when it's on:

```yaml
type: picture-entity
show_state: true
show_name: true
entity: input_boolean.white_noise_toggle
state_image:
  "off": local/awake.jpg
  "on": local/sleeping.jpg
name: White Noise
tap_action:
  action: toggle
hold_action:
  action: more-info
```

The `hold_action: more-info` thing is quite useful, as it can quickly indicate how long the white noise was on, approximating how long the nap has been so far (assuming the white noise does its job).

## Secondary controls

For additional control, in a separate [tab][tab-view] of the dashboard, I have the following:

[tab-view]: https://www.home-assistant.io/dashboards/views/

```yaml
type: vertical-stack
cards:
  - type: entities
    entities:
      - entity: media_player.googlehome1234
        type: custom:slider-entity-row
        icon: mdi:volume-high
        name: White noise volume
      - entity: input_boolean.white_noise_toggle
        secondary_info: last-changed
  - type: markdown
    content: "Note: White noise volume is usually 40%. If it's off, it shows as 0%."
```

This allows easily controlling the volume (when it's on!), reminds us of what the "usual" volume setting is, and also quickly displays how long ago it was last toggled. `slider-entity-row` is an extension, which can be obtained [here](https://github.com/thomasloven/lovelace-slider-entity-row).

## Quirks

While this setup works quite well, it has a couple of annoying quirks. Firstly, the Google Home plays a fairly loud chime before starting to play the white noise. Secondly, this involves the Google Home loading a ~300MB file. Originally I used ogg, and although it's usually cached, in some cases this could be a ~30-second process, with no user feedback visible. I've considered having the script play a shorter clip multiple times over, but the playback has unpleasant gaps in that case (and risks repeating that loud chime).

However, it seems that when pointing to an _mp3_ file, audio starts playing immediately, without having to first finish downloading the whole file. The Google Home is pretty opaque about this, but experimentation seems to show this is consistent.

## Afterword

Overall, this process of getting familiar with HomeAssistant and its various integrations has been delightful, with great community support and debuggability. My first thoughts were "I don't need this - my projects are simple and I can code them myself" - but the plethora of readily available integrations and the polished UI has made it well worth my time learning, and making changes is a breeze. And if my child sleeps better for it, that's a win in my book.
