---
title: "Timezone Changes"
date: 2023-10-16T19:54:39Z
slug: timezone-changes
tags:
- software
---

In October 2023, two weeks before daylight savings time ("summer time") was set
to end, Israel briefly considered delaying this. That would've been a terrible
idea, even if it weren't at war at the time.

<!--more-->

## A hacked toll tunnel?

Through the northern city of Haifa, the [Carmel Tunnels] are a toll bypass of
the city. About 10 years ago, on September 8-9, 2013 (yes that date will be
relevant), the tunnels were [shut down due to a "cyber attack"][hack-attack];
rumor is that the toll system didn't function, and rather than take the loss,
the tunnels stayed closed for many hours, causing traffic chaos.

[Carmel Tunnels]: https://en.wikipedia.org/wiki/Carmel_Tunnels
[hack-attack]: https://www.ynet.co.il/articles/0,7340,L-4446249,00.html

I don't think it was a cyber attack.

## Timezones in Israel

Timezone legislation in Israel is complicated (this sometimes [saves
lives][zionist-time]). Between 2005 and 2012, DST was set to end on the Last
Sunday before the 10th of Tishrei. Tishrei is a month in the traditional Jewish
calendar, which is less common in day-to-day use in Israel, but does determine
holidays (similar to Easter). However, legislation managed to change - twice -
between 2012 and 2013. The first change (November 2012) had DST ending on the
first Sunday after October 1st, and the second (2013) had DST ending on the
*last* Sunday of October.

[zionist-time]: https://darwinawards.com/darwin/darwin1999-38.html

{{< admonition >}}

Until 2013, the Israeli law for daylight savings time relied on the lunar
calendar, so the rule couldn't be represented easily using the Gregorian
calendar. If you look at the [timezone database] source data, you can see things
suddenly got very efficient:

[timezone database]: https://www.iana.org/time-zones

```text
# Rule> NAME>   FROM>   TO>     ->      IN>     ON>     AT>     SAVE>   LETTER/S
# ...explicit lines for every year since 1940...
Rule>   Zion>   2010>   only>   ->      Sep>    12>     2:00>   0>      S
Rule>   Zion>   2011>   only>   ->      Oct>     2>     2:00>   0>      S
Rule>   Zion>   2012>   only>   ->      Sep>    23>     2:00>   0>      S
Rule>   Zion>   2013>   max>    ->      Mar>    Fri>=23>2:00>   1:00>   D
Rule>   Zion>   2013>   max>    ->      Oct>    lastSun>2:00>   0>      S
# ...and that's it.
```

{{< /admonition >}}

Anyway, if one were to go by the pre-2012 law but apply it 2013, daylight
savings time should have ended on - you guessed it - September 8th. So, in my
opinion, a much likelier scenario than a "cyber attack" is simply that some of
the systems suddenly found themselves one hour out of sync with the rest, and
things got pretty confused. [Wikipedia notes][cellphone-confusion-wikipedia]
that, on this day (as well as October 6th, due to the 2012 law), many
smartphones showed an incorrect time because they hadn't been updated with the
latest legislation. And that's despite having, for September 8th, almost a
year's notice; expecting everyone's personal devices to be updated in two weeks
is pure fantasy.

[cellphone-confusion-wikipedia]: https://he.wikipedia.org/wiki/%D7%A9%D7%A2%D7%95%D7%9F_%D7%94%D7%A7%D7%99%D7%A5_%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C#%D7%94%D7%97%D7%95%D7%A7_%D7%94%D7%A0%D7%95%D7%9B%D7%97%D7%99_-_%D7%94%D7%97%D7%9C_%D7%9E%D7%A9%D7%A0%D7%AA_2013

## Nobody's up changing the clocks at 2AM

It's important to understand that this is how it all works; computer-based
systems have a file somewhere that says "this is when the daylight savings
change will happen", and things happen automatically on that basis; they have
to, for a simultaneous transition of all computing systems. Any change to that
timezone file takes time and effort to create, test, and distribute, for each
different type of computing system. This is not something to be done under time
pressure as a "would-be-nice"[^timezones-are-fickle]. Not unless you want to
have "cyber attacks".

[^timezones-are-fickle]: Many years ago, I described an effort to coerce the timezone system into a "change on demand" mode; see post [Timezones are fickle]({{< relref "timezones-are-fickle" >}}).
