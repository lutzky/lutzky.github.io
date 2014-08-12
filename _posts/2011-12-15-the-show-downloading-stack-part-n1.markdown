---
date: 2011-12-15 12:08:00
layout: post
title: The show downloading stack - part n+1
tags:
- show downloading
---

I've [already mentioned][1] my show downloading stack on this blog. It's
changed a bit since - I now use [Transmission](http://transmission-bt.org/)
rather than rtorrent, as it has the excellent `transmission-daemon` package
which has it acting exactly the way I like (without using `screen`). Also, it
now E-mails me when a torrent is done downloading. So while this may be how TV
works for you:

[1]: /2009/09/05/my-show-downloading-stack

1. Notice that a new episode is out
2. Torrent it
3. Wait for the download to finish
4. Watch it

...this is how TV works for me now:

1. Receive E-mail notification of a new downloaded episode
2. Watch it

Here's how it's done: First, write `/usr/local/bin/notify_torrent_done`:

{% highlight bash %}
#!/bin/bash
cat_the_message() {
cat <<EOF
Subject: Torrent done: $TR_TORRENT_NAME

Hello from transmission $TR_APP_VERSION at $(hostname). The following torrent
has completed:

Name: $TR_TORRENT_NAME
Finished at: $TR_TIME_LOCALTIME
Downloaded to: $TR_TORRENT_DIR
Hash: $TR_TORRENT_HASH

Enjoy!
EOF
}

RETVAL=1

while [[ $RETVAL != 0 ]]; do
    cat_the_message | msmtp -C /etc/msmtprc.transmission --from default -t your@email.address
    RETVAL=$?
done
{% endhighlight %}

The various environment variables will be set by transmission when it calls
this script. We rerun `msmtp` until it succeeds because you will often get a
"connection timed out" response from gmail (...at least on my ISP...). Here's
`/etc/msmtprc.transmission` which is relevant to gmail (this is a bit tricky
and took a lot of fiddling around with):


    defaults
    tls on
    tls_starttls on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    timeout 60

    account default
    host smtp.gmail.com
    port 587
    auth on
    user yourusername@gmail.com
    password yourpasswordhere
    from yourusername@gmail.com
    syslog LOG_MAIL


As usual, caution is required when saving your password in plaintext. I highly
recommend using Google's two-step authentication, which will have you creating
a one-time password for each application - use one of those one-time passwords
here.

Finally, in /etc/transmission-daemon/settings.json, add the following code:


    "script-torrent-done-enabled": true,
    "script-torrent-done-filename": "/usr/local/bin/notify_torrent_done",


**Important:** You need to run `/etc/init.d/transmission-daemon reload` at
this point, not `restart` - that would cause `settings.json` to be
rewritten from runtime configuration.

That's it. Enjoy!
