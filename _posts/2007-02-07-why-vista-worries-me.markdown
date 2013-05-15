---
date: 2007-02-07 18:22:00
layout: post
title: Why Vista worries me
tags:
- software
- security
---

I've heard [the latest Security Now](http://www.twit.tv/sn77), regarding the
debate between Dave Marsh and Peter Guttman on DRM in Windows Vista. While a
few good points were made, the major one - in my opinion - was not.  
  
DRM, in a practical sense, is deeply flawed: The idea is to give you your media
- say, a WMA piece of music - and a program to play it with - say, Windows
Media Player - but encrypt the media. Now, naturally, Media Player will need
the decryption key for the media, and the idea is that Media Player will verify
that you are allowed to listen to the song, and only then decrypt it - as it is
played.  
  
However, something is clearly wrong here - both the encrypted media and the
decryption key are sitting locally on your computer. It's like giving you a
locked box, as well as a butler (which will live in your house, where you
presumably have a shotgun) with the key, and telling the butler not to open the
box for anyone unauthorized. That is, you can open the Windows Media Player
executable with your favorite hex editor, and dig away for the key. This is, of
course, very complicated to do - but there are advanced ways of finding these
keys, and once they're found - they're out. That's why we keep hearing about
WMA and iTunes' equivalent format being cracked every once in a while, when
they change it. No matter how sophisticated the DRM, you still get both the
locked box and the key. They might build bigger butlers, but we can build
deadlier shotguns. (Sorry for the violent analogy, but DRM kinda does that to
me ;))  
  
So, what can the \*AA/Microsoft/Apple/DRM scapegoats inc. do about this? Well,
they could supposedly have Windows recognize that you are trying to view the
Windows Media Player executable, and stop you (I'd be surprised if they haven't
done this yet). However, currently you can still, for example, run Linux on the
computer, and use that to view the executable. And if, by some crazy
coincidence, all variants of Linux stop you from viewing the executable - you
can pick your favorite, change the source code so it doesn't, and use that. To
stop you from running whatever unprotected operating system you want, changes
to the hardware must be made.  
  
This is exactly what worries me about Vista. For the first time, we are seeing
major effects like HDMI/HDCP, where the operating system interacts with the
hardware directly to figure out exactly what the user is or isn't allowed to
do. Also, Vista boasts the "Trustworthy Computing" project, which is all too
reminiscent of "Trusted Computing" - a project in which, through integrating
protection from the bottom of the hardware (with a TPM, Trusted Platform Module
chip) to the top of the software, the computer verifies that it is only running
authorized operating systems, which run only authorized programs.  
  
Now, the media companies would love this. Say HD-DVD's been completely cracked,
and an alternative, open-source, unprotected player has been released. If your
system is TPM-protected, it simply won't allow this software to run. Your own
compiled applications can be forbidden from running as well, seeing as their
source code just might be the HD-DVD cracking code. Unauthorized operating
systems would, naturally, not be allowed to run.  
  
Now, I'm not explicitly blaming Microsoft for this. Fact of the matter is, the
protection they've built into Vista, although probably (for the reasons I've
mentioned) insufficient, was required by the media companies in order for
HD-DVD support to be (legally/technically) possible in Vista. Would Microsoft
go so far as to enable the horror scenario I've pictured above? Probably not.
But I do believe we all need to be aware of the risks, just to be on the safe
side.
