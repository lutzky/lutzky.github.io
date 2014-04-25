---
date: 2007-02-27 17:48:00
layout: post
title: Using Jabber from within the Technion
tags:
- networking
- technion
---
{% include JB/setup %}

A very neat find for those of you who want to use Jabber from within the
Technion, but with your client of choice rather than a web-based one: Many
Jabber servers, including Google Talk, support using Port 443 over SSL. Since
the Technion does not block outbound SSL connections, this will work there as
well. Be sure to mark the appropriate 'Use old SSL protocol' option in your
jabber client (that's what it's called in gaim and pidgin, at any rate).
