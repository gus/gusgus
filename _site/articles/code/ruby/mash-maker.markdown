# Makin' Mash - Map to Hash

<cite>May 31st, 2008</cite>

<img src="/images/articles/code/ruby/makin-mash.png" class="article" align="right">

[excerpt]
We all know and love the `map` method in Ruby (and other functional-ish languages). Given some list of objects, we get back an equal-sized array of potentially different objects. In Ruby we can `map` against arrays, hashes, sets, etc.; basically, anything that is `Enumerable`.

From time-to-time, though, I need to convert some list of object into a hash. Ergo, I need to `map-to-hash` or `mash`.
[/excerpt]

For instance, let's say I want to map an array of User records to a hash with email addresses pointing to the User records? Without much thought I could write it this way:

<macro:code lang="ruby">
  users = User.find(:all) # Not smart :)
  hashed_users = users.inject({}) do |acc,u| 
    acc[u.email] = u
    acc
  end
</macro:code>

I would rather do the following:

<macro:code lang="ruby">
  users = User.find(:all) # Still not smart :)
  hashed_users = users.mash {|u| {u.email => u} }
</macro:code>

It's not a **HUGE** change, but it does let me *say* what I want to *say* without all the **acc**umulator cruft.

## Implementation

Simple, straight forward, and usable by anything that is Enumerable.

<macro:code lang="ruby">
  module Enumerable
    def mash
      self.inject({}) { |a,i| a.merge( yield(i) ) }
    end
  end
</macro:code>

## Acknowledgements

After writing my `mash`, I realized others have probably done this many times before and a quick search found the below posts (Ruby specific). I was actually wrong about my assumption. I only found one post. Of course, I didn't search very hard and other languages probably do the same.

1. [Map array to hash](http://snippets.dzone.com/posts/show/4805) - There are actually one too many loops in [vinterbleg's](http://snippets.dzone.com/user/vinterbleg) implementation. And it's Array specific where it should be Enumerable generic.
