---
date: "2014-07-02T00:00:00Z"
slug: fakefile
aliases: ["/2014/07/02/fakefile/"]
summary:  A tiny python library for faking out filesystem operations for tests.
tags:
- software
- python
- testing
title: FakeFile
---

<!-- markdownlint-disable MD013 -->

I've recently been rewriting a mess of bash, tcsh and Python code as a Python script, and this has proven interesting to test. I've written a tiny Python library called `fakefile` to help out with it, so I can write code like this:

```python
import fakefile
import unittest
import mock

def my_function():
    with open("somefile", "w") as f:
        f.write("correct output")
    with open("existing_file", "w") as f:
        return f.read()


class TestMyCode(unittest.TestCase):
    def test_my_function(self):
        faker = fakefile.FakeFile()

        faker.set_contents("existing_file", "correct input")

        with mock.patch('__builtin__.open', faker.open):
            result = my_function()  # No file "somefile" will be created!
                                    # No file "existing_file" will be read!
        self.assertEquals(faker.files["somefile"].file_contents,
                          "correct output")
```

The library is available on github as [lutzky/fakefile](http://github.com/lutzky/fakefile). Naturally, however, it turns out I've been outdone by Google's [pyfakefs](https://pypi.python.org/pypi/pyfakefs). They have some clever bast^H^H^H^Hgooglers working there!
