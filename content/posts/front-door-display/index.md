---
title: "Front Door Display"
subtitle: ""
date: 2023-12-29
slug: front-door-display
tags: ["hardware"]
featuredImagePreview: no-case.png
---

<!--
    cSpell: words wokwi OLED pioled pitemp Ultimaker Onshape
-->

Let's make a tiny display for stuff you check right before leaving home!

<!--more-->

I keep forgetting to turn off my alarm as I leave home, and then scrambling to
turn it off[^turns-off-automatically]. Even if I do remember to turn it off, I'm
never quite sure that I did, so I take my phone out, open the appropriate app,
and check. It would be super convenient if I had a little indicator near the
door, so I (or anyone else leaving) could check more quickly. A single red LED
would technically do the job... but wouldn't be wife-approved.

[^turns-off-automatically]: The alarm app has added a feature, after I created the device described in this post, to turn it off if any indoors motion is detected at the appropriate time, mostly solving this issue.

I love [tiny OLED displays]({{%ref "pitemp#stage-2-pioled" %}}). Let's use one of
those! I got an [ESP8266 with an onboard OLED display][esp8266-with-display],
and thanks to [ESPhome][esphome], having a display of the alarm status is easy
enough. There's still plenty of room on the display, so I figured I can add a
couple of other things I quickly check before leaving home: Weather and tram
times. I used the [Edit Undo font][edit-undo-font] and some [Material
Icons][material-icons] for a bit of styling. I ended up having to mess with
exact spacing *a lot* until I was happy with it; it would be super helpful if
there were a simulator like [wokwi] for ESPHome to iterate on this more quickly!

[esp8266-with-display]: https://www.aliexpress.com/item/1005004839191268.html
[esphome]: https://esphome.io/
[edit-undo-font]: https://www.dafont.com/edit-undo.font
[material-icons]: https://fonts.google.com/icons
[wokwi]: https://wokwi.com/

{{< image src="no-case.png"
    caption="The resulting device without a case"
>}}

Next step is to create a case for it. This is necessary both for wife-approval
and for cleaner mounting to the wall. I use [Onshape] for this, as it's both
free and parametric - that is, I can change numbers later to adjust the design
without fully re-doing it; and if there's one thing I've learned about designing
for 3D printing, is that it takes a few iterations to get it right: Print, learn
that it *almost* works, adjust, repeat.

{{< image src="case-iterations.png"
  caption="Iterating on the case design in Onshape" >}}

[Onshape]: https://onshape.com

With this design, I got some nice [shadow lines]. I had originally planned to
use screws, but it turned out to be fairly annoying: While the PCB does have
holes for mounting screws, there isn't a lot of room for nuts; it ended up being
simpler to make a fully plastic snap-fit design. Snap-fit, especially with 3D
printing, is an even worse source of trial-and-error iterations, as there seems
to be a fine line between "doesn't snap" and "snaps off altogether", especially
with smaller designs.

[shadow lines]: https://www.youtube.com/watch?v=8dhFhU7Nl_0

It doesn't help that I'm using a somewhat older Ultimaker 5 printer with PLA
material; I know there are more modern and robust printers, but the Ultimaker 5
is maintained by experts at our maker room, which only allows PLA, and I figured
it should be doable. Thankfully, I was right! I'm really happy with the final
result, and it's proving to be at-a-glance useful every day.

{{< image src="final.png" caption="Final result" >}}
