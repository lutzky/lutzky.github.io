---
date: 2008-10-18 21:16:00
layout: post
title: Delegating methods in Ruby
tags:
- ruby
---

Sometimes, when constructing a compound object, we are interested in exporting
functionality while retaining encapsulation. For example, suppose we have a
`Secretary` class:

```ruby
class Secretary
  def send_fax(destination, fax_contents)
    puts 'Sending fax "%s" to %s' % [fax_contents, destination]
  end

  def answer_call(call)
    # ...
  end

  # ...
end
```

Our `Secretary` provides a lot of useful functionality, that our `Boss` class
would like to have. `Boss` would like to be able to say that he can send a fax,
without having the user explicitly request his `Secretary` beforehand. The same
goes for a lot of other methods `Secretary` provides. Instead of writing a stub
function for each of these methods, it would be nice to do the following:

```ruby
class Boss
  delegate_method :my_secretary, :send_fax, :answer_call

  def initialize
    @my_secretary = Secretary.new
  end
end

john = Boss.new
john.send_fax("Donald Trump", "YOU'RE fired")
```

Here's how we can get this to happen:

```ruby
class Class
  def delegate_method(instance_var_name, *method_names)
    method_names.each do |method_name|
      define_method(method_name) do |*args|
        instance_var = instance_variable_get("@%s" % instance_var_name)
        instance_var.send(method_name, *args)
      end
    end
  end
end
```

This solution does have its drawbacks - it will not work for methods which are
meant to accept blocks. I'm not sure how to get that to happen, short of using
a string-based `class_eval`, which I'm not very fond of. (I find `eval` to be,
well, evil...)
