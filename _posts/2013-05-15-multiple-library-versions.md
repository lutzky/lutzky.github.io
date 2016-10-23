---
layout: post
title: "Multiple library versions"
tags: [code, c, linux]
---

## Introduction

Assume you're working with an external vendor, who is providing you with code
for a wonderful function `getFoo`:

```cpp
// foo.h version 1.2.3

int getFoo();

// foo.c version 1.2.3

int getFoo() {
	sleep(1000); // TODO improve performance
	return 42
}
```

You use this function in many of your products - for example, in your
best-selling `barApp` application:

```cpp
// barApp.c

#include <stdio.h>

int main() {
	printf("%d\n", getFoo());
	return 0;
}
```

So `barApp`, and other applications, would want to use a `foo` library.  It
makes sense to provide this function in a shared library (`libfoo.so`).
However, this library will change in the future, in several ways:

1. Binary-compatible changes
  - Performance improvements (`sleep` will be removed)
  - Additional functionality will become available (new functions)
2. Binary-incompatibile changes - at the very least, recompilation will be necessary
  - For C, this is usually caused by changes to macros
  - For C++, a plethora of reasons: Virtual function reimplementation, function
    inlining, new private data members...
3. Source-incompatible changes - these will require you to change your source
   code (in `barApp`):
  - Functions (which you use) being removed or renamed
  - Semantic changes - `getFoo` could return 43

This gets even more complicated due to the fact that `barApp` is an operational,
mission-critical application for your organization. Developers may need to
hotfix older versions of `barApp`, which use older versions of `libfoo`. The build
servers and developer boxes will need to be able to have multiple versions of
`libfoo` installed simultaneously.

## Compiling, installing, and using a shared library properly

First, the upstream vendor should compile `libfoo.so` with an `SONAME`, like so:

```bash
gcc -shared -Wl,-soname,libfoo.so.1 -o libfoo.so.1.2.3 foo.c
objdump -x libfoo.so.1.2.3 | grep SONAME
# SONAME               libfoo.so.1
```

The guarantee the upstream vendor should give is this: As long as `SONAME`
doesn't change, binary compatibility will be retained.

Now, you (or, preferably, your package manager) should install the package on your machine like so:

```bash
mkdir -p /usr/include/foo1
cp foo.h /usr/include/foo1
cp libfoo.so.1.2.3 /usr/lib
ldconfig -v | grep libfoo
# libfoo.so.1 -> libfoo.so.1.2.3
```

Now, traditionally _another_ symlink `libfoo.so` -> `libfoo.so.1.2.3` would be
created, so you could compile `barApp` with `-lfoo`. However, here's an
alternative:

```bash
gcc -I/usr/include/foo1 -l:libfoo.so.1 barApp.c -o barApp
ldd barApp
# linux-vdso.so.1 =>  (0x00007fff8edfe000)
# libfoo.so.1 => /usr/lib/libfoo.so.1 (0x00007fb367cce000)
# libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fb367906000)
# /lib64/ld-linux-x86-64.so.2 (0x00007fb367ef2000)
```

Now `barApp` is compiled, and looks for `libfoo.so.1` - it will find it thanks
to the symlink created by `ldconfig`, and use `libfoo.so.1.2.3`.

## Aftermath

### Binary-compatible updates

Suppose a new, compatible, faster version of `libfoo` is released - say version
\1.3.0, which has removed that pesky `sleep`. Well, just place it in `/usr/lib`
and rerun `ldconfig`.

```bash
cp libfoo.so.1.3.0 /usr/lib
ldconfig -v | grep libfoo
# -> libfoo.so.1 -> libfoo.so.1.3.0
```

The symlink has been updated, and now all applications (`barApp`, for example)
which were linked against `libfoo.so.1` will have improved performance.

### Incompatible updates

Suppose a new, incompatible version 2.0.0 of `libfoo` is released, which would
force the newer `barApp2.0` to be recompiled against the new, different
headers. No problem:

```bash
mkdir -p /usr/include/foo2
cp foo.h /usr/include/foo2
cp libfoo.so.2.0.0 /usr/lib
ldconfig -v | grep libfoo
# -> libfoo.so.2 -> libfoo.so.2.0.0
# -> libfoo.so.1 -> libfoo.so.1.3.0
gcc -I/usr/include/foo2 -l:libfoo.so.2 barApp2.0.c -o barApp2.0
```

Both versions of `libfoo` are installed simultaneously, and do not conflict.

## Final thoughts

The [Debian policy guide][policy] states that `-dev` packages should include
the `libfoo.so` symlink. However, this would cause a conflict between the
`-dev` packages for two different generations of `libfoo`. I am curious as to
how this problem is solved "in the wild", as I'm sure Debian have good reasons
for suggesting this.

[policy]: http://www.debian.org/doc/debian-policy/ch-sharedlibs.html#s-sharedlibs-runtime
