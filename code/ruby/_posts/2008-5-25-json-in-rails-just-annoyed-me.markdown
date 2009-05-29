---
layout: post
title: JSON in Rails Just Annoyed Me
summary: Seriously, things just shouldn't be as hard as they are
---

Man. I was really having fun coding up JSON responses in one of my Rails apps. Until, that is, I wanted to do something custom.

Now, you might ask, *"Why would you want to do something custom?"*

To which I would reply, *"Sigh. Because I'm just that way."*

## Get on with it

<img src="http://farm1.static.flickr.com/191/503535890_b929f73b2e_m.jpg" align="right" class="article"/>

Ok, I've got this `ActiveRecord` model called `Fact`. `Fact` has attributes `:key` and `:value` along with the other normal columns (i.e. `:id`, `:created_at`, etc.).

I want to use `Fact` in one of my views and I export it to JSON. I only care about the `:key` and `:value` and the obvious solution is to:

{% highlight ruby %}
fact = Fact.create(:key => 'foo', :value => 'bar')
fact.to_json(:only => [:key, :value])
{% endhighlight %}

Which returns something like:

{% highlight javascript %}
{"key": "foo", "value": "bar"}
{% endhighlight %}

Ok ... fine. I can do something with that, but `Fact` is really an extension of some other model, which can have many `Facts`. And I want to reference these facts by their name in a JavaScript object. I don't want to search through the objects looking for a matching key. I want a JavaScript Object that looks something like:

{% highlight javascript %}
{"foo": "bar"}
{% endhighlight %}

You might say, *"Get over it!"*

I would say, *"No. This is what I want."*

I also figured it would be easy to modify `Fact` to return what I want. What I figured was that since I could call `to_json` on an `ActiveRecord`, the implementation of `to_json` would actually recursively work its way through the hierarchy of attributes and associations and call `to_json` on each of them. Thinking this was the case, I went and wrote my own `to_json` on `Fact`.

*"What happened?"*, you ask.

*"Bupkiss"*, I say.

*"What do you mean?"*, you persistently ask.

*"What's with all the questions!"*

The reason why nothing happens is because `to_json` hands responsibility over to the `ActiveRecord::Serialization::Serializer` class (ASS). `ASS` in turn builds up its own Hash of keys and values that it grabs from the `ActiveRecord` in question.

This is **NOT** what I would expect. Hence, my annoyance. In fact, I find it a little silly and a little broken. If this is what I expected, I would instead pass an instance of `Fact` to a JSON encoder and `Fact` would in fact know nothing of JSON. As it stands, `Fact` knows about JSON and JSON knows about `Fact` (by knowing about `ActiveRecord`).

## Whatchu goan do?

I don't know yet. I'll repost when I figure it out. I just wanted to post my annoyance. I am very, very annoyed.
