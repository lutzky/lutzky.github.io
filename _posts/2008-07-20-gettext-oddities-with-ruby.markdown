---
date: 2008-07-20 19:19:00
layout: post
title: Gettext oddities with Ruby
tags:
- ruby
---

I was having a lot of trouble with
[gettext](http://en.wikipedia.org/wiki/Gettext) in Ruby, mostly due to lacking
documentation. Here are some useful things I figured out while writing TTime. I
ended up having a single `gettext_settings.rb`, included from every file which
uses gettext. Here it is (with some extra notes)

{% highlight ruby %}
#!/usr/bin/ruby
begin
  require 'gettext'
  require 'pathname'

  include GetText

  # This fixes a swarm of problems on Windows
  GetText.locale.charset = "UTF-8"

  # Ruby's gettext acts in a sane
  # method - add a path to the set of paths
  # scanned.
  locale_in_data_path = Pathname.new($0).dirname + \
    "../data/locale/%{locale}/LC_MESSAGES/%{name}.mo"
  add_default_locale_path(locale_in_data_path.to_s)
  bound_text_domain = bindtextdomain("ttime")

  # For Glade, however, it only seems to
  # be possible to specify one path at a
  # time. Fortunately, gettext already
  # found it for us.
  my_current_mo = bound_text_domain.entries[0].current_mo
  if my_current_mo
    ENV["GETTEXT_PATH"] = my_current_mo.filename.gsub(
      /locale\/[^\/]+\/LC_MESSAGES.*/,
      "locale/")
  end
rescue LoadError
  def _ s #:nodoc:
    # No gettext? No problem.
    s
  end
end
{% endhighlight %}

One note for context: I use
[setup.rb](http://i.loveruby.net/en/projects/setup/) (and `ruby-pkg-tools`) to
package TTime. So my localizations go in `data/locale`.
