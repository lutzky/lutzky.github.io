---
date: "2007-02-14T22:23:00Z"
slug: heres-hoping
aliases: ["/2007/02/14/heres-hoping/"]
tags:
- technion
title: Here's hoping
---

```ruby
def factor(grade, params = {})
  return 100 if params.empty? # Optimistic, eh?

  case params[:type]
  when :pass
    return 55
  when :fail
    return 54
  when :root
    params[:gamma] = 0.5
  end

  grade = grade.to_f

  return params[:proc].call(grade) if params[:proc]

  grade *= params[:coefficient] if params[:coefficient]

  if params[:gamma]
    grade /= 100
    grade **= params[:gamma]
    grade *= 100
  end

  if params[:offset]
    grade += params[:offset]
  end

  return grade if params[:idnoclip]
  [ grade, 100 ].min
end
```
