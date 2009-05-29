---
layout: post
title: Active Record Modeling Life
summary: Code and Life intertwined ... ewwwwww
---
A quick observation I made about how `ActiveRecord` can be used to model life.

{% highlight bash %}
class Life < ActiveRecord::Base
  has_many :causes
  has_many :effects, :through => :causes
end
{% endhighlight %}
