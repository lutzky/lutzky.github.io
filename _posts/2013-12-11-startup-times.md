---
title: "Startup times"
excerpt: Starting new java processes in your scripts considered harmful. Let's compare "hello world" startup times for different languages.
tags: [code]
---

Lately, a facebook comment of mine on the subject of Java's slowness has proved quite popular, so here goes: Here's a listing of a few Hello World programs and running times for them (**including startup, which is a big deal in Java**) on my laptop:

```text
$ grep '^model name' /proc/cpuinfo | head -1
model name	: Intel(R) Core(TM) i5-3337U CPU @ 1.80GHz
$ uname -a
Linux orca 3.11.0-14-generic #21-Ubuntu SMP Tue Nov 12 17:04:55 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
```

The following script will be timed:

```bash
#!/bin/bash

n=$1

shift

for ((i=0; i < $n; i++)); do
	"$@" > /dev/null
done
```

Times are for `n=100`.

C
-

```c
#include <stdio.h>

int main(int argc, char * argv[]) {
  printf("Hello, world!\n");
  return 0;
}

/* Result: 0.17s
 * ...unless you give it a .cc extension, and then it's 0.30s!
 * It turns out that gcc/g++ guess the language from the file extension.
 */
```

C++
---

```cpp
#include <iostream>

int main(int argc, char * argv[]) {
    std::cout << "Hello, world!" << std::endl;
    return 0;
}

// Result: 0.30s
```

Python
------

```python
#!/usr/bin/python

print "Hello, world!"

# Result: 1.33s
```

Java
----

```java
public class Hello {
    public static void main(String args[]) {
        System.out.println("Hello, world!");
    }
}

// Result: 8.60s. No, I am not kidding.
```

There you have it. Sun's Java takes 28x-51x as much time to run "Hello World" (startup included) than native applications, and (shockingly, in my opinion) over 6x as much as non-precompiled Python. That's meaningless for long-running applications, but is a very big deal for small, often-run ones.
