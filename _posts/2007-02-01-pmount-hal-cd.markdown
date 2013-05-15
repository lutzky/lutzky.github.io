---
date: 2007-02-01 19:46:00
layout: post
title: Pmount-hal + cd
tags:
- linux
---

If you're like me, and don't use Gnome or KDE, then you probably use the pmount
or pmount-hal applications to mount removable media. Here's a neat thing to add
to your `.bash_aliases`:

{% highlight bash %}
function pmh {
    pmount-hal $1
    UDI=`hal-find-by-property --key block.device --string $1`
    cd "`hal-get-property --udi $UDI --key volume.mount_point`"
}
{% endhighlight %}
