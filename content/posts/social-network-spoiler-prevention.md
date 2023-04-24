---
date: "2014-04-26T00:00:00Z"
slug: social-network-spoiler-prevention
aliases: ["/2014/04/26/social-network-spoiler-prevention/"]
summary:  A feature proposal for avoiding spoilers on social networks.
title: Social network spoiler prevention
---

<!-- markdownlint-disable MD013 -->

There is a well-known problem on today's social network platforms - spoilers. Anyone watching a show and failing to immediately catch up to the latest episode will see a lot of posts on their feed dancing around the spoiler, and finally revealing it completely. This makes sense - people like to talk about their favorite shows, and social networks are a great place to do it.

What I'd like to suggest is a mechanism for mitigating the spoiler problem. This mechanism is optimized for Facebook, but could easily be applied to Google+, Twitter et cetera.

The short version:

* Mark potential spoilers, keeping track of what exactly they might be spoiling
  * Allow voluntary marking by the original poster
  * Allow reporting of spoilers, similarly to spam reports
* Collapse spoiler materials, showing what is being spoiled
* Allow users to view spoilers
  * When they do this, optionally "learn" that these spoilers can now safely be shown.

For an example, consider the following scenario: I'm watching the fantastic show Game of Scones, and in the latest episode - season 4, episode 3 - Lord Muffin has been surprisingly murdered. I might want to post the following status:

> OMG can't believe Lord Muffin was murdered no waayyyyyy

Now, one of the following happens:

* Before posting, I check a box saying "this status contains spoilers", clearly indicating Game of Scones S04E03.
* I post without checking the box, ticking off my spoiler-sensitive friends. Several unfriend me, but a few of them hit the "Spoiler alert" button adjacent to the post.
* Bonus points: The social network platform automatically recognizes the spoiler and asks me to mark it.

Once the post was marked, it looks like this:

> *Spoiler to Game of Scones S04E03 hidden.* **Click to unhide**

Clicking the "click to unhide" link should, naturally, show the status as it was originally posted. However, the social network can be smarter about this, and remember that as of now - spoilers to S04E03 are OK, and shouldn't be hidden from the user. A few notes about this:

* This shouldn't be done automatically, and a confirmation should be shown - at least at first ("Should spoilers for this episode still be hidden? *Show Spoilers*/*Keep hiding spoilers*")
* Posts containing spoilers should have a small visual indicator of them being as such. This is a good hint for what other people are seeing, and assists helpful users in marking spoilers.
* It would be useful to allow *searching* for spoilers - for example, if I just saw the episode and want to see what people are saying about it.

Finally, this is a neat signal that can be used by whatever social network implements it - imagine, a percentage graph of "how many people have already watched the latest episode". Seeing as many people Tivo or torrent episodes, that kind of data has got to be worth some money to someone.

Note that there are existing spoiler prevention mechanisms implemented as browser extensions, and what I'm suggesting is more complex and requires integration into the social network itself. This is important anyway, as you want the social network to work the same on any device or browser. Unfortunately, this also means that I am currently powerless to implement it. So if you think this is a good idea and know someone relevant, pass it along!
