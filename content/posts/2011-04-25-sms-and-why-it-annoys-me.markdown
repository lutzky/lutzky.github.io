---
date: "2011-04-25T16:58:00Z"
slug: sms-and-why-it-annoys-me
aliases: ["/2011/04/25/sms-and-why-it-annoys-me/"]
tags:
- phones
title: SMS and why it annoys me
---

Don't get me wrong. I love being able to communicate textually with friends,
coworkers and family. It's ideal for a noisy pub; a somewhat-private
conversation on a crowded bus; telling something to someone who may be asleep,
so they see it first thing when they wake up; making quick responses while in a
meeting without being rude (well, at least at my workplace it's considered
perfectly acceptable). It's also very handy when you want to tell someone
something they ought to write down, such as a phone number or something they
should remember to buy. My problem isn't with the concept of mobile textual
messaging - it's with SMS, the "Short Message Service", as provided by Israeli
carriers (and possibly worldwide).

The first problem I'd like to discuss is length. SMS messages are limited to
160 characters, or rather - 160 bytes. If your message includes any foreign
characters, such as Hebrew letters, then UTF-16 mode takes effect, and your
message is limited to 70 characters, which is ridiculously short. While the
name of the service, SMS, implies that the messages should indeed be short,
this is not the only common usage: If you want to have an actual conversation
with someone (and this is a perfectly reasonable situation), messages will be
longer than 160 characters, and certainly longer than 70. The problem becomes
worse if u dont want to use shorthands n skip punctuations like many smsers do.
(Ever found yourself about to send a 75-character message, going over it to
find 5 characters to trim without looking like an idiot?)

There have been several attempts to overcome the short-message problem, all of
them implemented as workarounds in cellphone software. The initial, primitive
approach was to simply split a message up into appropriately-sized chunks, and
send out those chunks as separate messages: A 150-character Hebrew message
would be sent out as 3 separate messages (70, 70, 10 characters respectively).
Later on, a mechanism was invented for the phones to detect the split messages,
stitch them back up on the recipient's phone, and notify the recipient if the
message is incomplete. Poor man's TCP.

The split-message solution is very problematic, especially when taking into
account two other problems with SMS: Reliability and price. The reliability
problem is subtle: SMS message _usually_ make it across, but when they don't
(and sometimes, in fact, they don't), no notification is given. Where E-mail
servers notify you about delivery failure, where instant messaging services
tell you that the other party has disconnected, SMS has... nothing. There's no
way to know that your message hasn't been received, unless a little-known,
not-supported-everywhere and highly annoying "read receipt" feature is enabled.

The price problem is completely absurd: I have a small 1GB plan at Orange,
which costs 70₪/month. That's 70 NIS / 1GB, 1GB being 109 bytes. That comes to
7 &times 10-6 Agorot per byte. Suppose that an SMS-style service would need a
bloated 100-byte header, so an SMS message is 260 bytes. Therefore, an SMS
message should cost 0.00182 Agorot. In reality, it costs 44 Agorot
(inter-carrier average) without a plan, or 14 Agorot (at best, requiring a
1000-SMS plan) with a plan. That's between 7692× and 24176× as much.

One additional problem with SMS is the fact that they're locked into your
device. Got a new phone? You have to go through a very complicated process to
transfer your SMS messages over, and this isn't possible for every phone. Lost
your old phone? Unless you were backing up manually, your messages are gone.
Have a separate work-phone? You'll need to use each phone to see messages sent
specifically to it. None of these problems occur with an online E-mail
provider, why should they happen with mobile texting?

With modern phones, sending and receiving E-mail is just as easy as sending and
receiving SMS messages. The main problem is that not everyone has a modern
phone, and E-mail on older phones is quite cumbersome. Worse yet, older phones
don't immediately notify you of E-mails. There could be some good money in
creating an E-mail-to-SMS gateway - and it would be quite convenient to use if
done properly. Imagine having your SMS messages united with your E-mails,
organized and searchable by your favorite E-mail client. If you have a modern
phone with proper E-mail notification and sending abilities, this could be very
handy. Just sayin'.

**Addendum:** It seems that [Google Voice][googvoicevideo] already does exactly
what I want, but is not available in Israel. Thanks, Shachar.

[googvoicevideo]: http://www.youtube.com/watch?v=zpgMJ7Hv6tk
