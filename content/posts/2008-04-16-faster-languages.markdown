---
date: "2008-04-16T00:49:00Z"
tags:
- software
- c
- python
title: Faster Languages
---

Due to an exercise in an AI course, I'm forced to confront an old nemesis -
C++. Part of the reason is that the exercise contains a time-limited
tournament, and the code needs to run very quickly. Another reason is, I guess,
the fact that C++ serves as a sort of lowest common denominator in the course
(which used, by the way, to be taught in LISP, along with the language).

I never liked C++ language much. As a matter of fact, I prefer C. I've been
going over some old code for a project, which needed to use DBus to talk to
NetworkManager. [Back then][1] I wrote it using Python, embedded in C - it
seemed easier at the time, due to lack of documentation. After hunting around,
I figured out how to do most of the stuff I wanted in C, using DBus's GLib API.

[1]: /2007/09/16/exception-handling-decorators-and-python/

In this process, the most helpful bit of documentation turned out to be GLib's.
GLib looks like a wonderful library to get big-program stuff done relatively
nicely in C, without mucking about in C++. Exception handling (of sorts),
object-oriented programming (of sorts) as well as garbage collection (of sorts)
are implemented in a usable way, and extremely well-documented.

At the end of the day, I was able to turn this Python gem:

```python
import dbus

def _nm_device_interface(dev_object):
    """Returns an interface to the device object dev_object"""
    return dbus.Interface(dev_object, NM_DEVICE_IFACE)

def _nm_get_object(object_path):
    """Returns an object with the given object path using the NM service"""
    return dbus.SystemBus().get_object(NM_SERVICE, object_path)

def _nm(): return _nm_get_object(NM_OBJECT_PATH)

def _nm_dbus_exception(e, guessed_exception):
    """Checks if the DBus exception e is (exactly) of type guessed_exception"""
    try:
        return e.get_dbus_name().endswith(guessed_exception)
    except:
        # If it doesn't have a get_dbus_name, it probably isn't the DBus
        # exception we're looking for.
        return False

def _nm_all_device_interfaces():
    """Return a list of interfaces to all devices NM sees"""
    try:
        return [ _nm_device_interface(_nm_get_object(devicename))
                    for devicename in _nm().getDevices() ]
    except dbus.DBusException, e:
        if _nm_dbus_exception(e, "NoDevices"):
            return [] # No devices means list of devices is empty
        else: raise
```

...into this C gem:

```cpp
#define DBUS_SERVICE_NM "org.freedesktop.NetworkManager"
#define DBUS_PATH_NM "/org/freedesktop/NetworkManager"
#define DBUS_INTERFACE_NM "org.freedesktop.NetworkManager"
#define NM_ERR_NODEVICES "org.freedesktop.NetworkManager.NoDevices"

gboolean is_remote_dbus_exception(GError *error, char * exception_name) {
        g_assert(error);

        if (error->domain != DBUS_GERROR ||
                        error->code != DBUS_GERROR_REMOTE_EXCEPTION)
                return FALSE;

        if (!exception_name)
                return TRUE;

        return strcmp(dbus_g_error_get_name(error), exception_name) == 0;
}

GPtrArray * get_nm_devices(DBusGConnection *connection, GError **err) {
        GError *tmp_error = NULL;
        DBusGProxy *proxy;
        GPtrArray *ptr_array;

        g_return_val_if_fail(connection != NULL, NULL);

        proxy = dbus_g_proxy_new_for_name(
                        connection,
                        DBUS_SERVICE_NM,
                        DBUS_PATH_NM,
                        DBUS_INTERFACE_NM);

        dbus_g_proxy_call(proxy, "getDevices", &tmp_error, G_TYPE_INVALID,
                        dbus_g_type_get_collection("GPtrArray",
                                DBUS_TYPE_G_PROXY), &ptr_array, G_TYPE_INVALID);

        if (tmp_error != NULL) {
                if (is_remote_dbus_exception(tmp_error, NM_ERR_NODEVICES)) {
                        g_error_free(tmp_error);
                        return NULL;
                }
                else {
                        g_propagate_error(err, tmp_error);
                        return NULL;
                }
        }

        g_object_unref(proxy);

        return ptr_array;
}
```

The C code runs much faster, and I suspect is more maintainable then its
original counterpart (which uses embedded python in C).
