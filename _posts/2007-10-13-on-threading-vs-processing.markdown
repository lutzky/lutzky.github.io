---
date: 2007-10-13 22:04:00
layout: post
title: On Threading vs. Processing
tags:
- code
- python
---

Writing multi-threaded applications in Python is often a headache because of
the Global Interpreter Lock - only one Python thread can run at any given
moment, which makes multi-threading useful only in the case where all modules
but one actually run C code. However, thanks to the impressive new [Python
Magazine](http://pythonmagazine.com), I've stumbled across a package called
`processing`, paraphrasing python's built-in `threading` package. Essentially,
the package provides an API identical to Python's threading, but uses processes
and pipes (or other mechanisms on non-posix operating systems) instead. What
the magazine does not cover is the fact that this can also benefit GUI
applications; updating a progressbar in the application doesn't need to slow
down heavy computations being done in a separate thread. To show how easy the
integration is, take the following example which shows usage of either threads
or processes at the user's choice:

```python
import processing
import threading
import Queue
import time
import gtk
import gobject

gtk.gdk.threads_init()

USE_PROCESSING = False
WORKER_DELAY = 1.0
GUI_DELAY = 0.5

def f(q, sq):
	print "Init other thread"
	i = 0
	while sq.empty():
		time.sleep(WORKER_DELAY)
		q.put(i)
		print "Other thread: %d" % i
		i += 1

def update_label((l, q, sq)):
	print "Updating label"
	try:
		i = q.get_nowait()
		l.set_text("Number in thread: %d" % i)
	except Queue.Empty:
		l.set_text("Queue is empty!")
	except processing.Queue.Empty:
		l.set_text("Queue is empty!")
	return sq.empty()

def close(window, sq):
	sq.put(True)
	gtk.main_quit()

if __name__ == '__main__':
	if USE_PROCESSING:
		q = processing.Queue()
		sq = processing.Queue()
		p = processing.Process(target = f,
			args = [q, sq])
	else:
		q = Queue.Queue()
		sq = Queue.Queue()
		p = threading.Thread(target = f,
			args = [q, sq])

	p.start()
	w = gtk.Window()
	l = gtk.Label()
	gobject.timeout_add(int(1000*GUI_DELAY),
		update_label, (l,q,sq))
	w.add(l)
	w.connect('destroy', close, sq)
	w.show_all()
	print "Mainloop!"
	gtk.main()
```
