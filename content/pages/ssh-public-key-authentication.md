---
title: SSH public key authentication
date: 2013-03-23 21:51:06
url: /linux-stuff/ssh-public-key-authentication/
---

If you find yourself logging into SSH servers a lot, you might find this tip
useful - you'll only need to type your password once per session. But first,
let's set the default username (so you don't have to tell SSH what user you are
every time):

<!-- markdownlint-disable MD010 -->

```console
$ cd ~
$ mkdir .ssh
$ chmod 700 .ssh
$ cat >> .ssh/config
Host t2.technion.ac.il
	User slutzky
Ctrl-D
$
```

Now, create a public/private key pair for SSH, like so:

```console
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/tactless/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): use_a_password
Enter same passphrase again: use_a_password
Your identification has been saved in /home/tactless/.ssh/id_rsa.
Your public key has been saved in /home/tactless/.ssh/id_rsa.pub.
The key fingerprint is:
5a:3a:e3:f4:6e:91:fe:3f:27:4e:f4:46:0d:5e:50:4f tactless@dolphin
```

Now you have a public and private key: `~/.ssh/id_rsa` is the private key
(don't give this to anyone!), and `~/.ssh/id_rsa.pub` is the public key - give
this to everyone. Specifically, put it on the SSH server you want to log into,
making sure the permissions are correct. There's a script which does this:

```shell
ssh-copy-id t2.technion.ac.il
```

It basically does the following for you:

```console
$ scp ~/.ssh/id_rsa.pub t2.technion.ac.il:
password:
$ ssh t2.technion.ac.il
> mkdir .ssh
> cat id_rsa.pub >> .ssh/authorized_keys
> chmod 700 .ssh .ssh/authorized_keys
> chmod 755 .
> logout
```

Now, when you log in to your local account, before using SSH for the first time,
type the following command:

```console
$ ssh-add
Enter passphrase for /home/tactless/.ssh/id_rsa: your-password-here
$ ssh t2.technion.ac.il
> # notice, didn't type a password
> logout
$ ssh t2.technion.ac.il
> # no password this time either
```
