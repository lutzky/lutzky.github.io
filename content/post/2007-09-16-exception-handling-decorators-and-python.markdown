---
date: "2007-09-16T14:02:00Z"
tags:
- code
- python
title: Exception handling, decorators, and python
---

Lately I've been working on a project that has me using DBus a lot. After
trying to figure out how to work DBus with C, and seeing how easy it is to do
in Python, we figured we'd try to use embedded Python to do this. Fortunately,
it's very simple to use - especially thanks to [this guide](http://www.developer.com/lang/other/article.php/2217941).

> It later turned out to be much easier to do in C, as described in _[Faster Languages](/2008/04/16/faster-languages)_.

Now, we couldn't have the Python code throwing exceptions outwards, so we had
each function return, along with its actual return value (if any), a numeric
code identifying the error. Unfortunately, this made the code get really big,
really fast - especially once DBus exceptions are thrown into the mix. But once
I learned how to use decorators, I accomplished something like this diff:

```diff
+@wrap_exceptions((False,))
 def checkSomething():
-    global error_string
-
-    error_string = ""
-
-    try:
-        return (try_doing_something_over_dbus(), RET_OK)
-    except dbus.DBusException, e:
-        error_string = str(e)
-        if _nm_dbus_exception(e, "ServiceUnknown"):
-            return (False, RET_SERVICE_NOT_RUNNING)
-        return (False, RET_ERROR)
-    except Exception, e:
-        error_string = str(e)
-        return (False, RET_ERROR)
-
+    return (try_doing_something_over_dbus(), RET_OK)
```

Now, the duplicate DBus/non-DBus exception handling, global `error_string`,
etc. - that happened in a lot of functions. Unfortunately, they didn't all
return their values in the same way. Some just returned a `RET_VALUE`, but most
had other values before it in the tuple (not the ideal design, come to think of
it...). Here's the decorator I wrote:

```python
class wrap_exceptions:
    def __init__(self, prepend_tuple=None):
        self.prepend_tuple = prepend_tuple

    def tuplize(self, retval):
        # Change retval into a default tuple form, if necessary
        if not self.prepend_tuple: return retval
        return tuple(list(self.prepend_tuple) + [retval])

    def __call__(self, f):
        def exception_wrapped(*args, **kargs):
            global error_string

            error_string = ""

            try:
                return f(*args, **kargs)
            except dbus.DBusException, e:
                # Check known DBus Exceptions first
                if _nm_dbus_exception(e, "ServiceUnknown"):
                    return self.tuplize(RET_SERVICE_NOT_RUNNING)

                # Unknown exceptions (DBus)
                error_string = str(e) # Includes get_dbus_name
                return self.tuplize(RET_ERROR)
            except Exception, e:
                # Unknown exceptions (non-DBus)
                error_string = repr(e)
                return self.tuplize(RET_ERROR)

        return exception_wrapped
```
