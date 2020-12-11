---
title: "Asserting string equality"
excerpt: When comparing long strings in unit tests, make sure your assertion failures give you useful output.
tags: [code, testing]
---

I've had several opportunities to write unit tests for code that outputs large
strings. It's important that your unit-testing framework handles this well.

Here's my example data:

```python
STRING_A = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut tempus dui.
Suspendisse ut augue placerat, venenatis ante a, aliquam nibh. Sed vitae massa
a nibh dignissim porta id rhoncus neque. Etiam commodo dapibus magna sit amet
pellentesque. Aenean venenatis vulputate eros, sit amet sagittis ligula laoreet
vel. Pellentesque consectetur viverra nunc, vel interdum turpis tempor nec.
Quisque vel purus in quam facilisis gravida posuere in mi. Aenean ligula sem,
mattis ut feugiat sit amet, lobortis ut sapien. Vestibulum laoreet aliquam
lorem pulvinar lobortis. Mauris quis orci lorem. Mauris ut ante id nulla
ultrices gravida vel et orci. Suspendisse potenti.
"""

STRING_B = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut tempus dui.
Suspendisse ut augue placerat, venenatis ante a, aliquam nibh. Sed vitae massa
a nibh dignissim porta id rhoncus neque. Etiam commodo dapibus magna sit amet
pellentesque. Aenean venenatls vulputate eros, sit amet sagittis ligula laoreet
vel. Pellentesque consectetur viverra nunc, vel interdum turpis tempor nec.
Quisque vel purus in quam facilisis gravida posuere in mi. Aenean ligula sem,
mattis ut feugiat sit amet, lobortis ut sapien. Vestibulum laoreet aliquam
lorem pulvinar lobortis. Mauris quis orci lorem. Mauris ut ante id nulla
ultrices gravida vel et orci. Suspendisse potenti.
"""
```

`STRING_A` and `STRING_B` are different, by one character. Can you tell which
one?  If you'd use your unit testing framework's equivalent of
`assertEqual(STRING_A, STRING_B)`, it would correctly report that they are
different. But would it help you identify the difference?

C#, for example, is quite horrible with this. It outputs both strings in their
entirety. In Visual Studio, it doesn't even seem to be possible to copy the
output into an external comparison tool. This has caused some developers
(myself included) to implement an ad-hoc "character-by-character string
equality tester".

For C++, if testing with Google's gtest library, the result is the same - the
entire strings are shown, and an external tool needs to be used to get a
reasonable indication of what the difference is.

Python 2.7's `assertMultiLineEqual` gives a good solution to the problem (in
Python 3, this becomes the default behavior for standard `assertEqual`). There
are similar comparison methods for other large data types.

Output:

```text
F
======================================================================
FAIL: testLongStringEquality (__main__.TestLongStrings)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/ohad/test/test_equal.py", line 35, in testLongStringEquality
    self.assertMultiLineEqual(STRING_A, STRING_B)
AssertionError: '\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut tempus dui. [truncated]... != '\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut tempus dui. [truncated]...
  
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut tempus dui.
  Suspendisse ut augue placerat, venenatis ante a, aliquam nibh. Sed vitae massa
  a nibh dignissim porta id rhoncus neque. Etiam commodo dapibus magna sit amet
- pellentesque. Aenean venenatis vulputate eros, sit amet sagittis ligula laoreet
?                             ^
+ pellentesque. Aenean venenatls vulputate eros, sit amet sagittis ligula laoreet
?                             ^
  vel. Pellentesque consectetur viverra nunc, vel interdum turpis tempor nec.
  Quisque vel purus in quam facilisis gravida posuere in mi. Aenean ligula sem,
  mattis ut feugiat sit amet, lobortis ut sapien. Vestibulum laoreet aliquam
  lorem pulvinar lobortis. Mauris quis orci lorem. Mauris ut ante id nulla
  ultrices gravida vel et orci. Suspendisse potenti.


----------------------------------------------------------------------
Ran 1 test in 0.003s

FAILED (failures=1)
```

For Java and JUnit, the output is also short and sweet (for plain `assertEquals`):

```text
testLongStringEquality(MyTest): expected:<...sque. Aenean venenat[i]s vulputate eros, si...> but was:<...sque. Aenean venenat[l]s vulputate eros, si...>
```

Does your unit testing framework provide helpful output for failed unit tests?
This is something you can and should demand of it.
