# Moving to Rails 2.2 Headaches - Vol 1

<cite>November 23, 2008</cite>

[excerpt]
I had an itch in my butt to move our little app to the latest and greatest version of Rails - `2.2.2`. It was really itching and against my better judgements, I dug right in there and went to picking at that itch.

I went about my normal business of doing a `sudo gem install rails` and then a `rake rails:freeze:gems`. Simple enough. Started my tests and holy crap ... tests were failing left and right! I mean, come on now. This is silly. We are basically cutting edge without being on the Edge. We use all the latest and greatest plugins and stuff. What the hell's going on here?
[/excerpt]

Being that I hate farting with functional tests, or really anything in Action Pack, I started with the unit tests. They're generally the easiest to resolve.

### Shoulda

Shoulda was failing thanks the internationalization efforts. Our `should_ensure_length_in_range` assertions were failing because the messages were expecting the old format. A look at [Shoulda's tickets](http://thoughtbot.lighthouseapp.com) yielded a [promising fix](http://thoughtbot.lighthouseapp.com/projects/5807/tickets/87-should_ensure_length_in_range-cant-work-with-rails22). Thank goodness, too.

From that fix, I pulled the attachment and just added it to our loaded libraries; as a temporary stop-gap until the Thoughbotters get around to a new release.

Hey Thoughbotters, if you happen to read this, could you also patch in [Paperclip #49](http://thoughtbot.lighthouseapp.com/projects/8794-paperclip/tickets/49), [Shoulda #112](http://thoughtbot.lighthouseapp.com/projects/5807-shoulda/tickets/112), and [Shoulda #97](http://thoughtbot.lighthouseapp.com/projects/5807-shoulda/tickets/97)? Mmmmmkay, thanks.

### HAML

Out of the unit tests already and into the functionals. Fudge!

My beloved HAML. How do I love thee. Already fixed up to support Rails `2.2.2` in `2.0.4`, but you never told me! Would have been helpful so I wasn't looking like an ass for 30 minutes.

Anyways, HAML was broken because of a cool, new accessor added to ActionView called ... `output_buffer`. And possibly from some other cool methods like `block_called_from_erb?`.

I fiddled around for another 15 minutes until I remembered that I had to `rake gem:unpack` it. We had frozen ourselves to `2.0.3`. Doh!

I am getting a bunch of these warnings from Rails now:

    DEPRECATION WARNING: @person will no longer be implicitly assigned to person. (called from tag at .../vendor/rails/actionpack/lib/action_view/helpers/active_record_helper.rb:249)

Thanks to this call:

    - render({:layout => 'person'}, :object => @person) do
      = invite_key_tag

Why I'm getting the warnings is beyond me. I can only imagine that it has something do with line 258 of `action_view/base.rb` which does not pass the `local_assigns` around if also rendering with a layout.

    elsif options[:partial]
      render_partial(options) # 258

Dear Rails, please stop this.

### Smurf

[I wrote it. I fixed it.](http://github.com/thumblemonks/smurf) Took 20 minutes. The Rails team got a little more clever and a little more OO about this one. [Previously](/code/ruby/smurf-rails-autominifying-js-css-plugin), asset inclusion went through a single `AssetTagHelper` method. Now, we have full blown `ActionView::Helpers::AssetTagHelper::JavaScriptSources` and `ActionView::Helpers::AssetTagHelper::StylesheetSources` classes which each encapsulate some nice behavior. The [code change](http://github.com/thumblemonks/smurf/commit/a45de3b84598ee61e274f1ae87a11850a09628ba#comments) for this fix is also less hacky, in my opinion.

One other thing I discovered while running tests, `sqlite3` doesn't just get added anymore. I had to add the following to my test helper setup:

    config.gem 'sqlite3-ruby', :lib => 'sqlite3'

Thanks to with Sam Schenkman-Moore's [comment #56](http://weblog.rubyonrails.org/2008/11/21/rails-2-2-i18n-http-validators-thread-safety-jruby-1-9-compatibility-docs).

### Calendar Date Select

Tim Charper was all over his [fix](http://github.com/timcharper/calendar_date_select/commit/68bdbf598b2f0271df1301869fc6940333802d66) to [calendar\_date\_select](http://github.com/timcharper/calendar_date_select). Seems that `ActionView::Helpers::InstanceTag.new` takes one less parameter now. The one where everyone was passing in `nil` ;)

### Calendar Builder

Tests were failing for the [calendar\_builder](http://github.com/collectiveidea/calendar_builder) plugin. I don't want to blame the [Collective Idea guys](http://collectiveidea.com/) for this problem, though. They were using `CaptureHelper#capture` in a class where they had included `CaptureHelper`, obviously. And it worked fine prior to Rails `2.2`. Post `2.1`, however, this class suffered the same fate as pre-2.0.4 HAML, which is the curse of the dreaded `nil output_buffer`.

The problem was simply that their class - named `Week` - was using `capture`, but not rendering it in any context that had access to the actual `output_buffer` instance variable. However, the calling method in `CalendarBuilder#calendar` did. So, a few [tweaks to the yields and blocks](http://github.com/jaknowlden/calendar_builder/commit/c5102ae881f812801fcd95ab104b9ea3c4b83a1d) and we were back on track.

Sent them a pull request. They're very cool guys who respond pretty quickly; in case your anxious to get ahold of the latest copy.

Also ran into a `sqlite3` problem running their tests, but this time I only had to add this to their test helper:

    gem `sqlite3-ruby`

### Routes

OMG. Just when I thought I was done; you know ... because all the tests were passing. I started the app up, sent my browser to `http://localhost:3000/` and ... 405 error:

    Only post requests are allowed
    ...
    vendor/rails/actionpack/lib/action_controller/routing/recognition_optimisation.rb:64:in `recognize_path'
    
WTF? What now? Nothing had changed in our routes or anything. The last couple lines of our routes.rb looked like this:

      ...
      map.resource :session
      map.resource :dashboard
      map.root :dashboard
      map.connect ':controller/:action/:id'
    end

Worked before. `http://localhost:3000/` should be trying to hit `DashboardsController#show` and then be redirected to `SessionsController#new` for not being logged in.

Hmmm ...

More hacking around. `http://localhost:3000/dashboard` works fine and does the redirect. `http://localhost:3000/session/new` does what it's supposed to, show the login page. Reading, reading, reading ... nothing. Tried watching the logs, but it only errored without telling me what it was trying to render.

On an absolute whim, I wondered "What if it's not even hitting show?" The documentation never said anything about a routes change, but hey ... Rails documentation isn't the best. So, seriously on a whim, out of nowhere, for no reason but to try, I made this one change:

    map.resource :dashboard, :only => [:show]

Holy f'ing crap! It worked. Back to normal. Whew ... `hg commit && hg push`. Yeah, we're using [Mercurial](http://www.selenic.com/mercurial/wiki/).

### Summary

I don't know. I guess this is normal behavior. Maybe some suggestions:

* Get the stuff done you were trying to get done before you upgrade :(
* Make sure you have upgraded every single one of your dependencies and make sure you haven't frozen anything to an older version ... else you'll be chasing your tail
