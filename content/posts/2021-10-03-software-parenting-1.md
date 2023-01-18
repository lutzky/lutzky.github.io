---
title: "Newborn parenting software - part 1"
date: 2021-10-03T17:00:00+01:00
summary: Choosing and hacking on baby tracking apps
tags: ["software", "life"]
categories: ["Newborn parenting software"]
---

<!-- markdownlint-disable MD013 -->

A few months ago, I became a father. To help overcome some of the challenges of raising a newborn, I decided to employ my standard MO - software; preferably the kind where I understand what it's doing. It's been working well, and I learned a lot doing it - several blog posts' worth, in fact.

For this story to make sense, it bears mentioning that our conditions are pretty much optimal for it: My employer provides a generous parental leave for the non-birth parent; we decided in advance to formula-feed, which allows us to share that load, which means we need to communicate about it; my partner is an early bird whereas I am a night-owl, meaning we essentially have separate shifts necessitating a handoff; and, critically, we're the type of people who _like_ everything being super-organized and scheduled and spreadsheet-y (calms us down, gives us an illusion of control). Furthermore, our baby is remarkably consistent, being hungry right about every 3 hours - so the question we ended up constantly asking (of each other and our phones) was "how long since the baby ate".

We knew in advance we'd need some sort of a baby tracking app, of which there are _many_. After some research, I found that few of the free ones are designed to be used from multiple devices (e.g. dad's and mom's phones), which is a hard requirement. We found two contenders: Baby+ and BabyBuddy.

## Baby+

[Baby+](https://philips-digital.com/baby-new/) is an Android and iPhone app for tracking babies; it follows [pregnancy+](https://philips-digital.com/pregnancy-new/), which we were quite happy with (especially as, before the birth, our responsiveness requirements were looser - I'll get to that). It can track quite a few things, but not Tummy Time for one (in our case it turns out to be pretty important). Like pregnancy+, the design is very aesthetically pleasing, and it regularly shows timely, short, and useful articles for the parents.

While the app does have cloud sync, it doesn't have a web UI (it's phone/tablet-only) nor an open HTTP API for me to reasonably code against. It does have an export function, but it's only really intended for importing by the app itself as backup. It's super-clunky to work with - I know because I ended up using it to perform some analysis with a spreadsheet("how long is the baby going between feeds").

The biggest disadvantage of Baby+ is that it doesn't _really_ support multiple users. From the app's internal FAQ (only available after installing it and setting up an account):

> **How can I use this app with my partner?**
>
> You can share the app by logging in with the **same email and password**. If you use your device and enter data (e.g. a note) then you need to minimise or close the app for it to send the new data to the server _[...]_.
>
> **Important**: the app is designed to be used by on person at a a time _[...]_ otherwise data can be overwritten or deleted. _[...]_ allow a few mins for the data to sync (the second device should also have the app closed for a few mins at this point so it can fetch the data _[...]_).
>
> Please note that you will encounter data loss if you are using the app on two devices at the same time.

I'd guess that the app basically talks to the server on startup, compares timestamps of its entire database, and downloads or uploads the entire database depending on which version is newer. The startup time checks out:

Starting Baby+ on an android phone, after closing it so it syncs, takes about 7 seconds; an eternity in screaming-baby-debug-time. Furthermore, that doesn't include sync time, and old data will be shown for a few more seconds before the sync is complete; that starts off with slight frights ("the baby didn't eat for 5 hours?! oh, wait, actually 1 hour"), and eventually devolves into distrusting the app.

This felt like a silly problem to have; almost any web-based app would have none of these issues. Furthermore, I thought, there's surely an open-source one where I could fix any annoyances I have myself. Indeed, that would be BabyBuddy.

## BabyBuddy

[BabyBuddy](https://github.com/babybuddy/babybuddy) is an open-source web app, self-described as "to help caregivers track sleep, feedings, diaper changes, and tummy time to learn about and predict baby's needs without (as much) guess work". I describe it as "the dumbest-sounding idea ever - sleep-deprived parents of newborns creating and maintaining baby-tracking software as a hobby". It turns out to be wonderful, and is what we use today. It requires self-hosting (but provides a button to do that easily on Heroku), but works remarkably well. It didn't work _exactly_ like I wanted, but that just provided ample opportunity to hack on it.

Before we could use it, I had to make it more mobile-friendly. While it technically worked on phones, it had several usability issues, which I described in [#229](https://github.com/babybuddy/babybuddy/issues/229): horizontal scrolling was needed in places; the "Timeline" view didn't show a lot of the critical bits of info, requiring more clicks; the contrast was too low for sunlight; and more. Fortunately, through some wonderful collaboration from the author, I was able to quickly get it into a wife-acceptable state and transition us over from Baby+.

As I hacked on the project, I added a [Gitpod](https://gitpod.io) [config](https://github.com/babybuddy/babybuddy/blob/master/.gitpod.yml) and a link to the README. This allows people to hack on Babybuddy without installing any software whatsoever - everything is done through, essentially, a free tier cloud instance (on which my config will install everything needed) with a browser-builtin VSCode UI. I used this today to whip up [another pull request](https://github.com/babybuddy/babybuddy/pull/316).

In addition to being quick and comfortable to use, BabyBuddy allowed me to set up two integrations that I had in mind. The first is an always-on display, essentially intended as "the baby clock". It's positioned by the couch where we usually feed, so it's great as a feeding timer as well. I had started out with an old tablet (Huawei T3 Mediapad) running [wallpanel](https://github.com/thanksmister/wallpanel-android) - this is a form of "kiosk" application, which locks the device into a mode where it always runs the browser on a particular page (the device has no other credentials on it, so it's reasonably safe). The tablet's battery, unfortunately, did _not_ like that - seemingly having the screen on discharges it faster than it can charge, and after a few weeks the tablet refused to charge at all. I've therefore switched to using an old ASUS C100P Chromebook running [kiosk](https://chrome.google.com/webstore/detail/kiosk/afhcomalholahplbjhnmahkoekoijban?hl=en) - this gives the benefit of having a physical keyboard, useful for entering the food amounts.

The second integration I call "poobuttons" - a couple of tactile buttons on the changing dresser which tell BabyBuddy to mark a diaper (they are labeled "poo" and "pee"). This is both easier than fumbling with a phone touchscreen and, frankly, way more satisfying. The next posts will detail the iterations of these buttons and how I built them.

This has been a wonderful and challenging journey so far. I wonder what else I'll find myself building.
