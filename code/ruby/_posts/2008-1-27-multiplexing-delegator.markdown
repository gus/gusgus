---
layout: post
title: Multiplexing Delegator
summary: One person's brainfart is another person's gas-powered wind balloon
---

I've got a `User`, see, and this `User` has a fever. And the only prescription for this fever is more `Network` (get [even more fever](http://www.vimeo.com/17746)). In fact, this `User` already has two `Networks`.

{% highlight ruby %}
class Network
  # The idea is that each of the accessors has an array of Users
  attr_accessor :active, :pending, :rejected
end

class User
  attr_accessor :friend_network, :public_network
  def initialize
    @friend_network = Network.new
    @public_network = Network.new
  end
end
{% endhighlight %}

*This is, of course, a very simplified implementation of a solution that might be built in Rails with ActiveRecord.*

That's awesome. I can work with each of these `Networks` by adding to and removing from each of them individually. But, what if I wanted the list of all `Users` that a particular User is linked to and I don't care which Network they are in?

I could do this if I wanted all of the active users:

{% highlight ruby %}
user.friend_network.active + user.public_network.active
{% endhighlight %}

Or, I could push the logic into the model as would be expected; like so:

{% highlight ruby %}
class User
  # ...
  def all_active_users
    @friend_network.active + @public_network.active
  end
end
{% endhighlight %}

That's fine. But what if I wanted the list of all rejected `Users`? What if I wanted to add more feverish `Networks`? A lot more code, that's what!

## Interpretation

So, of course, a solution is forthcoming. What I really want to do is delegate a single message across multiple receivers and aggregate the results into a single response. Kind of like I'm multiplexing messages and demultiplexing the response.

Here's an example of what I would like to do given a User instance:

{% highlight ruby %}
user.entire_network.active
{% endhighlight %}

What should happen in this call is that `entire_network` should know how to call `active` on both the `friend_network` and `public_network` accessors, and then collect the results into a single collection of Users.

Thusly and so forth, the `Multiplexing Delegator` has been born. Let the dust settle a little ... and here is how I would define the `User` class:

{% highlight ruby %}
class User
  attr_accessor :friend_network, :public_network

  multiplex :entire_network, :across => [:friend_network, :public_network]

  def initialize
    @friend_network = Network.new
    @public_network = Network.new
  end
end
{% endhighlight %}

Assuming `friend_network` contains 3 `Users` and `public_network` contains 5 `Users`, a call to `entire_network` will return an array with 7 `Users`.

## Application

I know what you're saying, *"Sure. It works great for your example, but what else is it useful for?"*

And I say, *"I don't really care all that much since it's useful for me in this instance."*

But really, that's not true. I do care; lest I wouldn't have gone through all this effort to impress you. I see can `mutliplex` as being useful for aggregating any and many collections easily into one stream of results. Generally, the types of Objects being delegated to will be the same, but this does not have to be true.

Here's something fun I did:

{% highlight ruby %}
class Object
  multiplex :all_methods,
    :across => [:public_methods, :protected_methods, :private_methods]
end
obj = Object.new
obj.all_methods => [...] # Produced an array of all of the methods
{% endhighlight %}

No ... it does not match what is returned from `Object.methods`.

## Installation

Simple and easy:

{% highlight ruby %}
gem install multiplexing_delegator
# or if you're boring
sudo gem install multiplexing_delegator
{% endhighlight %}

[Documentation](http://glomp.rubyforge.org/multiplexing_delegator) is served from [RubyForge](http://rubyforge.org/projects/glomp), just like the [source code](http://glomp.rubyforge.org/svn/multiplexing_delegator).
