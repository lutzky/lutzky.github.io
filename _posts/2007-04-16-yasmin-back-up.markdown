---
date: 2007-04-16 10:43:00
title: Yasmin back up
tags:
- linux
---

Why was it down, you ask? Well, it was out here in the lab, because of a
shortage of network ports in the server room. From the acpid log:

`[Sun Apr 15 18:53:07 2007] received event "button/power PWRF 00000080 00000001"`

That is, at 18:53, someone simply pushed the power button. The server promptly
closed all processes and properly shut itself down. I've moved it into the
server room now...
