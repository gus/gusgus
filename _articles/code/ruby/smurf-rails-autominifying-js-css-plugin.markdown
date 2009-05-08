# Smurf - Rails Javascript &amp; CSS Auto-minifying plugin

<cite>November 8th, 2008</cite>

<img src="/images/articles/code/ruby/mini-thor.jpg" align="left" width="250" height="250">

[excerpt]
> *[Smurf](http://github.com/thumblemonks/smurf) can be found on Git Hub :)*

You know how Rails 2.x has this cool feature for bundling sets of Javascript or CSS files? Yeah, they call it something like ... `cache`. Crazy. I know. It's cool and all, but why does not it also minify that content? I mean, it's not like the content is going to change. You're only really going to be using this caching approach in production. Why couldn't it just do the minification on the big, concatenated file before it saved it?

Not understanding it, I went in search of those plugins which would do just what I want. I just knew they were out there. They were:

1. Not going to make me do anything else than use `:cache` in my `include` and `link` tags
2. Not going make me turn any features on or setup any configuration do-hickeys
3. Would minify Javascript and CSS
4. Just going to minify content
[/excerpt]

Yeah. No. Nothing to meet that criteria. I did find a [few](http://github.com/sbecker/asset_packager/tree/master) [implementations](http://github.com/timcharper/bundle-fu/tree/master). A [friend](http://sneer.org) also turned me onto a [Rack minifier](http://github.com/lucianopanaro/rack-javascript-minifier/tree/master) which does make a lot of sense, if you're running Rack. But, nothing that just did what I wanted.

So, as I've told others, if you're going to be a critic you should at least try to do better. Ergo, [Smurf](http://github.com/thumblemonks/smurf).

## What does it do?

I did a little digging into Rails to find out how I could get what I want. It didn't take all that long. Just look in `ActionView::Helpers::AssetTagHelper` for a private method called `join_asset_file_contents`. This is the method that takes a list of files, joins their contents together and returns the concatenated content.

Whoa. That's what I want! All of the content together. In one stream. With that, I can just run the combined content through an appropriate minifier.

And I did. I found Uladzislau Latynski's [jsmin.rb](http://javascript.crockford.com/jsmin.rb), which is a port of Douglas Crockford's [jsmin.c](http://javascript.crockford.com/jsmin.c) library. I adapted Uladzislau's code a little and suddenly had a JS minifier.

But, what about a CSS minifier? I looked around a little, but nothing stood out as elegant, so I rolled my own. It may not be the best, but it's short and I can actually read what it's doing. For example, here's how I compress a stream of CSS:

    content.compress_whitespace.remove_comments.remove_spaces_outside_block.
      remove_spaces_inside_block.trim_last_semicolon

You'll just have to [look at the code](http://github.com/thumblemonks/smurf/tree/master/lib/smurf/stylesheet.rb) to see how I do it. SPOILER ALERT: I do it with regular expressions! *(use your high-pitched theatrical voice for that part)*

Because I Hijack (that's my contribution to software patterns ... Hijacking) the nifty Rails method that returns content and just return minified content, I don't need to do any friggin' thing else. And neither do you.

Install the plugin and you're done. Hell yeah!

    ./script/plugin install git://github.com/thumblemonks/smurf.git

Make sure you have this in at least your `production.rb`:

    config.action_controller.perform_caching = true

And then make sure you are using the `:cache` option with your `javascript_include_tag` and `stylesheet_link_tag` statements.

## Miscellany

I suggest [this](http://maintainable.com/articles/rails_asset_cache) approach for cleaning up cached files if you need to do it for testing.

However, a simple `cap deploy` will "get rid of" of any cached files you have in production.

## References

1. [Mini Thor](http://www.robertcasumbal.com/blog/?p=114) - Drawing by [Robert Casumbal](http://www.robertcasumbal.com/)
