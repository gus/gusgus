---
layout: post
title: Changes in Riot 0.10
summary: Changes to the Ruby, Riot testing framework in version 0.10
published: true
---

Though I've never blogged about [Riot](http://github.com/thumblemonks/riot), it received some awesome and much unexpected attention from [Alex Young](http://alexyoung.org/2009/10/26/riot-testing/) (a super-awesome dude), [Ruby Inside](http://www.rubyinside.com/riot-for-fast-expressive-and-focused-unit-tests-2669.html) via [Ric Roberts](http://www.ricroberts.com/) (another super-awesome dude), [Rails Envy](http://railsenvy.com/2009/10/28/episode-098), and [Ruby5](http://ruby5.envylabs.com/episodes/24-episode-23-october-30-2009/stories/186-riot-testing-framework). I was overcome to say the least, partly because I wasn't happy with where Riot was at that moment, but mostly because I wrote Riot for me and didn't think anyone (except for [toothrot](http://toothrot.net/) and [jonpliske](http://github.com/jonpliske)) would actually think Riot was for them.

I was wrong.

In the short period of time between then and now I have received a lot of positive feedback and only vicariously have seen some negative feedback ... which I will ignore because - as I said before - I wrote Riot for me. Also in that time I have received some of that famous help from the open-source community. [annealer](http://annealer.org) and [brianc](http://github.com/brianc) (also the lead singer of [Dead Black Hearts](http://deadblackhearts.com/) - which is awesome) helped me to narrow in on what Riot was trying to accomplish and to do it with a more efficient engine. I'm happy to say I'm much happier with how Riot is implemented today than I was when [0.9.12](http://gemcutter.org/gems/riot/versions/0.9.12) was released.

"Whatever! The changes, Jabberjaw", you exclaim. Fine. In terms of DSL, there aren't many changes.

#### Assertion macros

The biggest observable change by far is in the way you write assertion macros, such as: `equals`, `raises`, `kind_of`, etc. You won't need to do this very often, but when you do you won't be defining a new method that can be included into `Riot::Assertion`. Now, you will be writing an assertion macro block. But, examples are the best way to show this. So, instead of writing the `exists` macros like this:

{% highlight ruby %}
module My
  module AssertionMacros

    def kind_of(expected)
      actual.kind_of?(expected) || fail("expected kind of #{expected}, not #{actual.inspect}")
    end

  end
end
{% endhighlight %}

you're going to write them like this:

{% highlight ruby %}
class Riot::Assertion

  assertion(:kind_of) do |actual, expected|
    actual.kind_of?(expected) ? pass : fail("expected kind of #{expected}, not #{actual.inspect}")
  end

end
{% endhighlight %}

Why? That has a lot to do with the under-the-hood changes. Important to note are a few things:

1. The obvious closure
2. The `actual` value is getting provided-to and no longer requested-by the assertion macro
3. The `pass` and `fail` signals which are required to be returned from any assertion macro

Not listed here is an `error` signal, but you shouldn't need to worry about that.

#### Shortcut assertion for the topic

The assertion shortcut `topic` has been renamed to `asserts_topic`, which brianc so elegantly suggested as a better name. Thus, instead of this:

{% highlight ruby %}
context "foo" do
  setup { "mom" }
  topic.kind_of(String) # This will no longer work
end
{% endhighlight %}

you would now do the following:

{% highlight ruby %}
context "foo" do
  setup { "mom" }
  asserts_topic.kind_of(String)
end
{% endhighlight %}

brianc added another shortcut for doing the same thing, which also allows you to have a custom description. You could write the above example like so:

{% highlight ruby %}
context "foo" do
  setup { "mom" }
  asserts("the topic is").kind_of(String)
end
{% endhighlight %}

#### Story output

After looking at what Alex Young [did for output](http://alexyoung.org/2009/11/04/riotjs/) in his implementation of [Riot for JavaScript](http://github.com/alexyoung/riotjs), I fell in love. So, this is now the default output format for Riot and what I'm calling the Story Report since the output kind of reads like a story.

<img src="/images/articles/code/ruby/riot-0-10-1-story-terminal.png" alt="Riot terminal output, story report">

Who doesn't like pictures?

#### Under the hood

Oh man, everything is a little different. In essence, it's a complete re-write. This re-write was going after a few things:

1. Riot needed to be faster. Twice as fast as Shoulda is not compelling.
2. Riot should keep less state (be more functional), because state is a terrible thing to change
3. Riot should not run the tests while also parsing the DSL (this REALLY bugged me)

In order to accomplish (1) and (3), annealer actually did some [crazy spiking](http://github.com/thumblemonks/riot/blob/7cf674c257fbb2e465116ad31b7721c5cba9b23a/lib/riot/experiment.rb) on what we called the experimental approach. Essentially, anonymous classes, `define_method`s, and meta-programming galore. And it was good.

But, it did not get me (2) in a way that I thought was most readable. Experimental was a bit too magical for even me and that's probably because I'm not that smart. So, we applied the learnings from experimental with an approach that never changed the state of a Context, Assertion, or Situation and we came up with the hybrid approach. I should say that Context, Assertion, and Situation have state, but the intention is for it not to change while the tests are running. Instead, state should be defined when initializing (or setting up) the respective element.

All of this combined into some really readable code that is now Riot `0.10`. There are more changes, but you should read the code to discover them. The [benchmarks](http://gist.github.com/240353) are pretty awesome, too. Especially those for Ruby 1.9. If you ask me, there's no reason to use mini-test when writing new tests for 1.9. Just switch to Riot ;)

As an aside, the instance that does change state over the course of running a test-suite is the test reporter. I can live with it for now, but it'd be pretty awesome if the reporter could go stateless. It would also be pretty sweet if someone would run Riot contexts through one of the parallel test distributors out there. The performance gains would be outrageous. If annealer ever finishes his implementation of Jenga, I wouldn't have to ask. Ahem!

## Riot Rails

I would really like some help building out Riot to have custom support for Rails. I started [Riot Rails](http://github.com/thumblemonks/riot_rails) and am slowly adding things as I'm working on a custom Rails app, but the progress is slow. The progress is slow mainly because I have also side-tracked myself with learning Clojure. I want to learn Clojure because a) I like Lisp, b) I like functional languages, and c) I want to re-write [Evoke](http://github.com/thumblemonks/evoke) with [Compojure](http://github.com/weavejester/compojure).

Now, re-writing Evoke in Clojure is a simple enough task (except for the delayed job processing which I'll have port over), but Clojure is a JVM language. This means Compojure is dependent on Java libraries like: jetty, apache commons, clojure-contrib, etc. Being dependent on so many libraries is just begging for package management and I suppose Maven provides that, but I dislike Maven and Ant for all of their XML horrificness (I used to be a Java programmer). I just hate it. Makes me want to barf. What I do like is Ruby Gems. I really like Ruby Gems. Turns out, annealer hates Maven and likes Ruby Gems as well. So ... what do you think we did?

[JavaGems](http://javagems.org), that's what. We up and [did it](http://github.com/javagems) and there will be a LOT more to say about that. However, all of this side-trackiness has kept me from finishing Riot Rails which is not all that hard of a thing to do, it just takes time and as I have already shown I can lose that very quickly.

Thusly and therefore, I'm calling all arms. Let's get Riot Rails finished. It'll accomplish what I set out to do, make functional tests in Rails faster. That's right! Slowness of Shoulda + Factory Girl + functional-tests made me write Riot. That's why Riot only calls `setup` once per Context. That's why finishing Riot Rails will make me oh so very happy.

If you'd like to help, but not sure how, hop into the `#riot` room on irc.freenode.net. Ohhhhh ... the riot room, that's funny. I know, it's really a channel, but whatever! If you don't want to do that, just fork and fix.
