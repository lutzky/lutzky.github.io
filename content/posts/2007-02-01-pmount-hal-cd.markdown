---
date: "2007-02-01T19:46:00Z"
tags:
- linux
title: Pmount-hal + cd
---

If you're like me, and don't use Gnome or KDE, then you probably use the pmount
or pmount-hal applications to mount removable media. Here's a neat thing to add
to your `.bash_aliases`:

```bash
function pmh {
    pmount-hal $1
    UDI=`hal-find-by-property --key block.device --string $1`
    cd "`hal-get-property --udi $UDI --key volume.mount_point`"
}
```
