# GusGus

This is the code for my own personal [blog](http://gusg.us) software and the articles that go with it. I got tired of crap like Mephisto, Typo, etc. with more bloat than I wanted. Moderating spam comments (even with Akismet) was just annoying. I always wrote my articles locally in Markdown and then did the post, preview, post, preview, ... junk until it looked on the site itself.

Now, I can run everything from my local box and see how it looks. Then, I commit it to my repository, do a little code deployment in production, and then tell Passenger to restart.

I don't need a stupid database. I don't need nuthin'! Awesome!

## How it works

*Coming soon!*

## Installation

If for some reason you are seeing this code and want to know how to get it running, here's what you'll need:

* Sinatra - sudo gem install sinatra
* BlueCloth - sudo gem install BlueCloth
* Syntaxi - sudo gem install syntaxi

Done

## Running It

#### Development mode:

    ruby gusgus.rb

#### Production mode:

    rackup config.ru

Or run it through Phusion Passenger.

# License

Coypright 2008 - Justin Knowlden {gus at gusg dot us}

Do not use any of these articles or this code for anything, at all, ever; without telling me about it and acknowledging me as the source first. When I say tell me about it, I mean send me an email with your intents, where you're using the content, and some way for me to contact you (like an email address).
