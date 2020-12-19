---
date: 2009-04-18 16:45:00
title: Timezones are fickle
tags:
- linux
---

I've been trying to work out a system to be able to cleanly switch between IST
(Israel Standard Time, GMT+2:00) and IDT (Israel Daylight savings Time,
GMT+3:00) on command. The logical way to do this, in my opinion, is to have two
separate files in `/usr/share/zoneinfo`, say `IsraelIST` and
`IsraelIDT`, and copy (or link) the relevant one as
`/etc/localtime`. The trick is creating the `IsraelIDT` file.

My first guess was the following zic source-file:

```
# Zone    NAME                GMTOFF  RULES/SAVE  FORMAT [UNTIL]
Zone      IsraelIDT           2:00    01:00       IDT
```

Now, this almost works. The problem is that both `is_dst` is set and
`timezone = -10800` (3 hours - should be 2, as it should represent local
standard time), so some software double-compensates here for a grand total of
GMT+4:00. After some research (walking through `__tzfile_read` gave the
biggest hint), it turns out that `timezone` is set according to the
minimal local time type which is _transitioned into_. So I came up with
this file:

```
# Rule  NAME    FROM  TO    TYPE  IN   ON       AT    SAVE  LETTER/S
Rule    ZionIDT min   1939  -     Jan  1        00:00 1:00  D
Rule    ZionIDT 1939  only  -     Jan  1        00:00 0:00  S
Rule    ZionIDT 1940  max   -     Jan  1        00:00 1:00  D

# Zone    NAME                GMTOFF  RULES/SAVE  FORMAT  [UNTIL]
Zone      IsraelIDT           2:00    ZionIDT     I%sT
```

Sounds about right, nay? Even my handy little
[pyzdump](http://github.com/lutzky/pyzdump) confirms that it looks about how I
want it to:

```console
$ ./pyzdump.py /usr/share/zoneinfo/IsraelIDT
Transitions: ['At Sat Dec 31 23:00:00 1938, switch to IST',
'At Sun Dec 31 22:00:00 1939, switch to IDT']
Types: [<tztype dst="True" idt:="" utc+10800="">,
<tztype dst="False" ist:="" utc+7200="">]
```

However, it still doesn't work. A test program:

```cpp
int main() {
    tzset();
    time_t t = time(NULL);
    printf("Timezone name is %s, timezone=%ld\n",
            __tzname[1], timezone);
    printf("The time is %s", ctime(&t));
    printf("Timezone name is %s, timezone=%ld\n",
            __tzname[1], timezone);
    return 0;
}
```

And its results, as run at 14:42:17 UTC, which is 19:42:17 IDT:

```
Timezone name is IDT, timezone=-7200
The time is Sat Apr 18 14:42:17 2009
Timezone name is UTC, timezone=0
```

Or, as I described it to a friend:

> Me: Hi computer, do you know what timezone are we in?
>
> Computer: Yeah, it's Israel Daylight Savings time, GMT+2:00 for standard time.
>
> Me: OK, and what time is it?
>
> Computer: 14:42
>
> Me: No, that's 3 hours late. What timezone are we in?
>
> Computer: Umm... UTC?
>
> Me: You just said IDT.
>
> Computer: Nuh-uh.

I'll get to the bottom of this eventually :/

**Addendum:** It seems that the problem is even more complicated. For the
following timezone file, C programs seem to work fine:

```
# Rule  NAME    FROM  TO    TYPE  IN   ON       AT    SAVE  LETTER/S
Rule    ZionIDT min   1939  -     Jan  1        00:00 1:00  D
Rule    ZionIDT 1939  only  -     Jan  1        00:00 0:00  S
Rule    ZionIDT 1940  2030  -     Jan  1        00:00 1:00  D
Rule    ZionIDT 2030  max   -     Jan  1        00:00 0:00  S
# Zone    NAME                GMTOFF  RULES/SAVE  FORMAT  [UNTIL]
Zone      IsraelIDT           2:00    ZionIDT     I%sT
```

However, Python programs still show `timezone = -10800`. Examining
Python's code, I found this:

```cpp
if( janzone < julyzone ) {
    /* DST is reversed in the southern hemisphere */
    PyModule_AddIntConstant(m, "timezone", julyzone);
    PyModule_AddIntConstant(m, "altzone", janzone);
    PyModule_AddIntConstant(m, "daylight",
        janzone != julyzone);
    PyModule_AddObject(m, "tzname",
        Py_BuildValue("(zz)",
        julyname, janname));
    } else {
        PyModule_AddIntConstant(m, "timezone", janzone);
        PyModule_AddIntConstant(m, "altzone", julyzone);
        PyModule_AddIntConstant(m, "daylight",
            janzone != julyzone);
        PyModule_AddObject(m, "tzname",
            Py_BuildValue("(zz)",
            janname, julyname));
}
```

And since June and July have the same timezone in our case, there's a good
chance that this is what's going wrong. The moral of the story seems to be this
- I should go with the first, simplest "always-DST" solution. Programs should
ignore the `timezone` variable, as in our context it isn't reliable. In
general, all internal time handling should be done in UTC; when reading times
from the outside world, if they are in local time - use `mktime`. If
they are in a specified timezone, use `timegm` and compensate manually.
I'd love to hear better ideas in the comments.
