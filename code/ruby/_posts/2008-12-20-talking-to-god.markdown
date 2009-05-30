---
layout: post
title: Talking to God
summary: It should just be easier
---

I recently started writing my [Evoke](http://github.com/thumblemonks/evoke) service (a nice, little [Sinatra](http://sinatra.rubyforge.org/) app). Part of the Evoke service is actually delivering on the promise of calling a stored URL back, which I achieved by storing a runner as a [delayed job](http://github.com/tobi/delayed_job). Only half the battle is writing the consumer, though. The other half is ensuring that the runner is daemonized and that the daemon is restarted if ever it were to die. This is where [god](http://god.rubyforge.org/) enters the picture.

For the Evoke consumer, I wrote a little god script that I package with the Evoke bundle. This script is easily configured to run from the command like so (relative to the evoke source code):

{% highlight bash %}
god -c config/evoke.god
{% endhighlight %}

With that, the consumer is running and will be restarted if ever it dies. With Evoke, I added a status page which can be accessed via the world-wide-web. Status just shows me a few things about the particular Evoke instance, like: a view of the last 10 callbacks, how many callbacks in total, how many coming up, are any callbacks still pending that should not be, etc.

To this status page I also added a little checker to make sure the Evoke consumer was running. If running, I get a nice green "running"; else, I get a nasty red "not running". Naturally - god being a ruby app and all - I wanted to ask god if it was running. As it turns out, this is not as straightforward as it would seem.

*I see now that this article is going to be hard to get through without a lot of giggling on my part*

### One would think

One would think that they could just require in the `god` library and use the API to ask for the state of a particular job. In my head, I would do this from IRB:

{% highlight ruby %}
require 'god'
God.status('evoke_consumer')
=> {:state => :up}
{% endhighlight %}

But ... nope. No way that I could see that is. So I went digging through the source and eventually had to find my way to the god shell script that gets executed from the command line. Which then led me to `God::CLI::CommandLine`. This is the only place where we can see the mysteries of god. `DRb` droppings. The info I need being printed to standard out. Everything I need to make one call, but all wrapped into a command line interface. I clearly cannot call any methods here.

It's also clear that god was not intended to be accessed through more than one interface, without a lot of redundant code. Basically, I am forced into command line mode or parsing the results of an execution, unless I want some hackery. Hackery it is. After a little playing around and dealing with permissions and such (which is very cool of DRb and god to take care of for me), I wrote this little method into my `Status` class:

{% highlight ruby %}
def consumer_running?
  DRb.start_service("druby://127.0.0.1:0")
  server = DRbObject.new(nil, God::Socket.socket(17165))

  server.status["evoke_consumer"][:state] == :up
rescue DRb::DRbConnError
  false
ensure
  DRb.stop_service
end
{% endhighlight %}

Most of that is straight up jacked from god (except for the `DRb.stop_service` :o ). I don't see why that would be so hard for god to let me do with what I intended earlier:

{% highlight ruby %}
God.status('evoke_consumer')
{% endhighlight %}

Come on god! Get with the program!

Anyways, I intend to fix god so that I can do that. Hopefully, the master of god will accept?!?! I may be way out of my mind here and there may be a much easier way to do this. If so, shoot me an email (see address in the footer) with the solution.
