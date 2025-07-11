---
title: "Newborn parenting software - part 4"
date: 2025-07-10
slug: software-parenting-4
summary: "Booby buttons! 😄"
subtitle: "Booby buttons! 😄"
tags: ["software", "life", "hardware"]
categories: ["Newborn parenting software"]
resources:
- name: "featured-image"
  src: "title.webp"
---

About 4 years later, we've done it again! With kid #2, we're older, wiser, more
tired, and have a slightly different strategy. We still love tracking stuff,
and BabyBuddy (a self-hosted baby tracking application) is still
[the best option]({{< ref "posts/software-parenting-1" >}}). However, a
couple of things have changed: First, the
[poo buttons]({{< ref "posts/software-parenting-2" >}}) have largely been
replaced with a wall-mounted tablet displaying our HomeAssistant UI (which,
indeed, has buttons for nappy recording). Secondly, and more significantly -
kid #2 is breastfed.

One of the advantages of breastfeeding is that some moms can, in the middle of
the night, feed a hungry baby while barely waking up themselves. Unfortunately,
if mom is interested in tracking the breastfeeding, and needs to
unlock the phone (*multiple times*) and perform additional taps, this doesn't
work, and she wakes up. Most interactive software is, perhaps unsurprisingly,
designed for people who are *wide awake*.

<!-- cSpell: ignore SOMRIG -->

So - home automation to the rescue! I already have a bunch of IKEA shortcut
buttons which work nicely with HomeAssistant through a my
[ConnBee 2][connbee-2], and IKEA's newer
[SOMRIG shortcut buttons][shortcut-buttons]
provide 2-buttons-in-1. All I need is 3 options (provided by 2 such SOMRIG
units) - "start timer", "stop timer and mark that as a left-breast feeding",
and "stop timer and mark that as right-breast".

[connbee-2]: https://phoscon.de/en/conbee2
[shortcut-buttons]: https://www.ikea.com/ie/en/p/somrig-shortcut-button-white-smart-70560347/

These button devices are wonderfully compact and their batteries last pretty
long. This has to do with the fact that they have no screen, so unfortunately
no way of indicating whether they worked or not; and they don't always work on
the first click. Fortunately, I had an old IKEA desk-lamp with a Zigbee RGB
lightbulb I hadn't really found use for. This lamp has now become a floor-based
night-light to indicate the status:

1. Dim blue when the timer is on (during feeding)
2. When feeding is done, green or orange for a few seconds (depending on the side)
3. ...and back off.

Indeed, a few smart buttons and a literal lightbulb-moment of an idea are
allowing my wife to go back to sleep much more quickly, without giving up on
our shared tracking obsession. It's amazing how much of a quality-of-life
difference you can make with some straightforward home automation.
