---
title: Git While You Sit 1 - Add --patch
excerpt: Using <code>git add -p</code> to eliminate those pesky <code>printf</code>-debugging statements.
tags:
- git-while-you-sit
- git
---

This is part of the "Git While You Sit" series, a play on Google's [Testing on the Toilet](http://googletesting.blogspot.co.il/2007/01/introducing-testing-on-toilet.html). It's intended to fit on a printed page. Currently Chrome doesn't seem to correctly print columns, but Firefox does.
{: .no-print }

Ever find yourself `printf`-debugging? You found the bug, but now you have `printf` statements all over the place. Running `git diff`, you get:

```diff
diff --git a/hello.c b/hello.c
index 93ca08c..c7d354a 100644
--- a/hello.c
+++ b/hello.c
@@ -4,6 +4,7 @@
 void b();
 
 void a() {
+    printf("Bug is here?\n");
     return;
 }

@@ -13,9 +14,10 @@ int main() {
 
     printf("Hello, world!\n");
 
-    return 1;
+    return 0; // Found it!
 }
 
 void b() {
+    printf("Bug is here?\n");
     return;
 }
 
```

It's actually pretty easy to get rid of them. Run `git add -p` and you will be shown each patch "hunk" separately:

```diff
diff --git a/hello.c b/hello.c
index 93ca08c..c7d354a 100644
--- a/hello.c
+++ b/hello.c
@@ -4,6 +4,7 @@
 void b();
 
 void a() {
+    printf("Bug is here?\n");
     return;
 }
### Stage this hunk [...]? n (No) ###
@@ -13,9 +14,10 @@ int main() {
 
     printf("Hello, world!\n");
 
-    return 1;
+    return 0; // Found it!
 }
 
 void b() {
+    printf("Bug is here?\n");
     return;
 }
### Stage this hunk? [...] s (Split)  ###
@@ -13,7 +14,7 @@ int main() {
 
     printf("Hello, world!\n");
 
-    return 1;
+    return 0; // Found it!

### Stage this hunk [...]? y (Yes) ###
 void b() {
+    printf("Bug is here?\n");
     return;
 }
### Stage this hunk [...]? n (No) ###
```

Now, only the `return 0` line is stage for commit. To get rid of the rest of the changes, run `git checkout -- hello.c`. Now the `printf` statements have been removed!
