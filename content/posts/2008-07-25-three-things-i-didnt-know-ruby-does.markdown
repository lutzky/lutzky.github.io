---
date: "2008-07-25T17:55:00Z"
slug: three-things-i-didnt-know-ruby-does
aliases: ["/2008/07/25/three-things-i-didnt-know-ruby-does/"]
tags:
- software
- ruby
title: Three things I didn't know Ruby does
---

**Edit: I was misled!**

Illustrated here. Hints below.

```irb
>> def inspect_x_and_y(x,y); puts "x: %p, y: %p" % [x, y]; end
=> nil
>> inspect_x_and_y(y={"hello" => "world"},x=[1,2,3])
x: {"hello"=>"world"}, y: [1, 2, 3]
```

The bits I didn't know about:

1. `"Format strings using a %% sign, %s, %s!" % [ "just like in python", "but
   with arrays" ]`
2. The `%p` formatting character is the same as `inspect`.
3. You can call methods with `method_name(param2=val2, param1=val1)`, also like
   in python. **No you can't! This code sets external variables called y and
   x.**

How embarassing... :(
