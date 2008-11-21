# Rails: Quick Find Plugin for More Sensible Access to Active Records

<cite>DATE NEEDED</cite>

[excerpt]
I have a good friend who'll rename nameless - ahem [Dan Hodos](http://danhodos.com) - who wrote a cool "plugin" for [work](http://centro.net) called Lazy Load Attribute. Very ironically, Dan was too lazy to make it a publicly accessible plugin.

As I was working through a specific and non-work related codebase, I found myself repeating a very similar pattern to the one that he had abstracted with Lazy Load Attribute. Not having the plugin available, I went and made it a damn plugin. I also extended it ever so slightly to handle some niceties I had already implemented.

I know. You want to ask *"What does this plugin do?"* So just ask it.
[/excerpt]

**Fine!** I'll tell you anyways.

Quick Find let's me do this in my `Rails` code

[code lang="ruby"]
User['john@doe.com']
[/code]

If I do this in my `ActiveRecord` model

[code lang="ruby"]
class User < ActiveRecord::Base
  quick_find :email
end
[/code]

Yep, you got it. Quick Find makes it easy to do what you would normally do with find_by's. The equivalent without Quick Find would be:

[code lang="ruby"]
User.find_by_email('john@doe.com')
[/code]

How boring and typie.

Quick Find comes especially in handy with lookup like tables. Because ... if you do something like this:

[code lang="ruby"]
class EventType < ActiveRecord::Base
  quick_find :key, :indifferent_access => true
end
[/code]

You can then do any of these and get the same result:

[code lang="ruby"]
EventType['meeting']
EventType[:meeting]
[/code]

But wait, there's more. Let's say you just want to access everything in this new-fangled way and you don't want to mix uses. Quick Find will default to `:id` if no attribute is defined as the lookup column.

For instance:

[code lang="ruby"]
class Job < ActiveRecord::Base
  quick_find
end
[/code]

Makes `Job` accessible via its `:id` like this:

[code lang="ruby"]
Job[1]
[/code]

Enlightening! I know.

Finally, if nothing is found, then nil is returned. Quick Find will not return a `ActiveRecord` error.

# Installation

Install it as a plugin for now in your Rails app.

[code lang="ruby"]
./script/plugin install quick_find
[/code]

[Quick Find](http://glomp.rubyforge.org/svn/plugins/quick_find) is hosted on [RubyForge](http://glomp.rubyforge.org).
