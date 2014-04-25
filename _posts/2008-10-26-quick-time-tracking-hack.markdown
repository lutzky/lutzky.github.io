---
date: 2008-10-26 18:57:00
layout: post
title: Quick time tracking hack
tags:
- linux
---
{% include JB/setup %}

Gnome 2.24 adds a new Time Tracking feature, which I would have found useful. I
don't have Gnome 2.24 at work, but I do have a Unix-based operating system...
Here's my new `~/bin/track`:

{% highlight bash %}
#!/bin/bash
date >> ~/time_tracking
vim ~/time_tracking +
{% endhighlight %}

Now, if I could only get vim to automatically hit "A" and space for me
afterwards... (I'm betting there's a way to do it, but AFAIK vim can only
receive ex-mode commands as parameters).

**Edit:** ...and, of course it's possible. Here's the new version:

{% highlight bash %}
#!/bin/bash
echo "`date` " >> ~/time_tracking
vim ~/time_tracking + -c 'startinsert!'
{% endhighlight %}
