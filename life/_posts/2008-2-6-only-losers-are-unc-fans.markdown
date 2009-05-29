---
layout: post
title: Only Losers are UNC Fans - With Tests
summary: It's not JUST a game, man!
---

I'm a Duke basketball fan; there, I admitted it. I didn't always like them, though. I have loved Kentucky since I was a little kid; in large part because of Rick Pitino and because they were just plain good and because I grew up in Ohio when there weren't any good teams.

In that time, Duke beat Kentucky on many occasions causing me much angst. But as I got older I began to respect Duke if only for Coach K. He's such a damn good coach. He can take any rag-tag team of somebody's and turn them into an even better team.

My mistake was telling a few UNC fans (and I do mean Duke's neighbor) at work that I was a Duke fan. All hell broke loose.

*"Duke sucks"* was the consistent mantra of the group. And lonely me; sitting there ... having to take it ... because I'm just oh so humble and non-confrontational.

They went so far as to tell me in code how they felt about it:

{% highlight bash %}
# This test is guaranteed to pass! 
def test_justin_is_a_nancy
  justin = HoopsFan.find(:nancy => true) 
  assert_equal “Fairweather Nancy”, justin.real_name 
end
{% endhighlight %}

So, of course it is my Pride's duty to respond. Here is the proof that all UNC fans are also losers:

{% highlight bash %}
def test_only_losers_are_unc_fans
  losers = HoopNuts.find(:all, :conditions => ['kast = ?', 'loser'])
  unc_fans = HoopNuts.find(:all, :conditions => ['team = ?', 'UNC'])

  assert_same losers, unc_fans
  assert losers.length > 0
end
{% endhighlight %}

*If you don't know already, it's Ruby with ActiveRecord sprinklings.*
