---
title: "Adventures with slow boot"
date: 2024-06-23
slug: slow-boot
tags: ["software"]
---

<!-- cspell: word netdata, anacron -->

Rebooting a modern desktop computer really shouldn't take very long, so when it
was somewhat-regularly taking well over 10 minutes just to shut down, I got
curious, and ended up looking at netdata, jitter, anacron, and even ansible.

<!--more-->

By default in Ubuntu, the shutdown process is hidden, but pressing ESC showed
that anacron was waiting on something indefinitely... and indeed, given a few
dozen minutes, it would complete. Sure, Raising Small Elephants Is Utterly
Boring[^mnemonic] can fix that, but something seemed wrong.

[^mnemonic]: This is a mnemonic for Alt+SysRq+{r,s,e,i,u,b}, a somewhat
  aggressive mechanism to [reboot a linux system][magic-sysrq-key].

[magic-sysrq-key]: https://en.wikipedia.org/wiki/Magic_SysRq_key

Adding some logging to anacron, it turned out that the bit which was taking so
long was something called `netdata-updater`.

## Netdata

There's lots of ways to get information about your various networked machines,
but my favorite for works-out-of-the-box laziness is
[netdata](https://www.netdata.cloud/). I like to run this on my desktop as well,
so I can retroactively diagnose issues or obsess over the specific fan speeds
that led to a mildly annoying hum in the quiet evening.

Netdata installs a self-update cron job, which is sensible. It's installed in
`/etc/cron.daily`, which by default is launched every day at 6:25 AM. This would
cause all machines it's installed on, within a timezone, to hit the servers
simultaneously; to avoid this, they added *jitter* - the update script randomly
waits between 0 and `NETDATA_UPDATER_JITTER`, the default being 60 minutes. So,
if you're trying to reboot just after 06:25 AM, you're probably going to wait an
extra 30-ish minutes.

Although adding jitter arguably makes sense on systems running *cron*, it makes
far less sense on ones running *Anacron*.

## Anacron

Cron works well for machines that stay on all the time, e.g. servers. However,
machines that are often off or suspended would likely miss the specific timing
of the scheduled tasks. For such machines, anacron is used instead, and tries to
make sure that daily tasks still occur daily: Once an hour, anacron will wake up
(if the machine is on) and check whether any daily tasks still need to be run
that day. That means that if I first turn on my computer in the evening, it has
updates and wants to reboot, and I let it - I have a really high chance of
`netdata-updater` being called, and of this little maneuver costing me 30-ish
minute of precious gaming time.

Anacron naturally introduces jitter, and anacron has additional
jitter-introducing mechanisms[^randomized_delay_sec].  Indeed, there's no need
to add jitter to `netdata-updater` running under anacron, so I changed
`NETDATA_UPDATER_JITTER` to 0, and indeed [my suggestion to make this the
default under anacron][netdata-anacron-bug] was accepted.

[netdata-anacron-bug]: https://github.com/netdata/netdata/issues/17745
[^randomized_delay_sec]: In Ubuntu 24.04, this is accomplished by the `anacron.timer` systemd unit having `RandomizedDelaySec=5m` configured.

That being said, it still seemed there's no good reason for shutdown to wait
over 10 minutes for anacron to shutdown. The shutdown screen showed that the
timeout was infinite, although the systemd default[^systemd-default] is 90
seconds. That's because `anacron.service` has this line:

[^systemd-default]: `DefaultTimeoutStopSec` under `man 5 systemd-system.conf`

```ini
TimeoutStopSec=infinity
```

<!-- cspell: ignore cronie -->

This was added [in this commit][infinite-timeout-commit], to resolve [this
bug][infinite-timeout-bug]. A more elegant solution is possible, but discouraged
because anacron is meant to be replaced by something called "cronie"; [I am
familiar with this pain][deprecated-not-ready-yet].

[infinite-timeout-commit]: https://salsa.debian.org/debian/anacron/-/commit/e83000966d446830ad93eef7af2c5ea62efe01db
[infinite-timeout-bug]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=915379
[deprecated-not-ready-yet]: https://goomics.net/50/

One way or another, I disagree with the reasoning, at least in my own particular
case, and have decided to comment out the infinite timeout line.

## Remembering this config

<!-- cspell: ignore dotfiles -->

I like to version-control and automate my configuration. I've been doing this
for [my dotfiles][dotfiles] for quite a while, but not for my overall machine
config. Tweaks like this, to my system config, are something I'd rather have a
script to do rather than writing it down in a checklist.

[dotfiles]: https://github.com/lutzky/dotfiles

As it turns out, [Ansible] is considered to be a good tool for this. I thought
it's only useful for "apply some settings to a large set of servers", but
apparently "maintain config for my one server" is not such a strange use-case.
I'm completely unfamiliar with Ansible; a coworker tells me that's because I've
worked at Google[^tech-island] for almost 10 years, and that's roughly as long
as Ansible's been well-known.

[Ansible]: https://www.ansible.com/
[^tech-island]: Google is known for having a "tech island", and specifically the
  type of problems which Ansible deals with, at least in my line of work, have
  preexisting in-house solutions, so I never had the chance to learn Ansible.

After a bit of futzing around, I've come up with this `playbook.yml`:

<!-- cspell: ignore lineinfile -->

```yaml
- name: Fix slow shutdown
  hosts: all
  tasks:
    - name: Finite timeout for anacron
      become: true
      lineinfile:
        path: /usr/lib/systemd/system/anacron.service
        regexp: 'TimeoutStopSec=infinity'
        line: '# TimeoutStopSec=infinity # Causes slow shutdown'
    - name: Force netdata jitter to 0
      become: true
      lineinfile:
        path: /etc/netdata/netdata-updater.conf
        regexp: '^NETDATA_UPDATER_JITTER=.*'
        line: 'NETDATA_UPDATER_JITTER="0"'
```

Then, to get everything to play nice with the local config, I have this `ansible.cfg`:

```ini
[defaults]
inventory = inventory
```

And this `inventory`:

```text
localhost ansible_connection=local
```

Sure, this could've been a shell script, but this seems easier to extend and
maintain. One thing I like about this is that I can run `ansible-playbook
--check --diff playbook.yml`, and get a preview of what it'll do. I'll likely be
looking deeper into ansible and seeing whether it's worthwhile getting it to
maintain some of my server configs.

This has been a fun dive into a slight annoyance with my system, and as always I
ended up learning a few interesting things. Please do jitter your clients, but
please don't leave users hanging.  Also, feel free to let me know in the
comments that I'm holding Ansible wrong 😄.
