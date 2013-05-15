---
layout: page
title: Shallow and Pedantic
tagline: Like calculus in a kiddie pool
---
{% include JB/setup %}
    
# Posts

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span><a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
