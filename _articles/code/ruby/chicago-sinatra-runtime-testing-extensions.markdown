# Chicago - Sinatra Framework Runtime &amp; Testing Extensions

<cite>December 15th, 2008</cite>

[excerpt]
I know I've [said it before](/code/ruby/sinatra-autohandling-css), but I love [Sinatra](http://sinatra.rubyforge.org/). It's simple and clean and great for almost any project you can think of that you know is not a heavy user-interfacing site. Under the auspices of [Thumble Monks](http://github.com/thumblemonks), we ([Gabe](http://annealer.org) and I) have developed [several](https://github.com/thumblemonks/evoke/tree) [sinatra](https://github.com/thumblemonks/grudge/tree) [based](https://github.com/thumblemonks/iamjacks/tree) systems (just to name a few).

The bitter-sweetness of Sinatra's lightweight-iness is that it does not provide methods for many of the common things one might do in an HTTP-based app. But, since our first Sinatra app, we've noticed several patterns that we keep re-using. So, we decided to bundle what we have so far into a gem called [Chicago](https://github.com/thumblemonks/chicago/tree).

But wait, there's more. We [also love](/code/ruby/should-making-dry-even-dryier) [Shoulda](http://thoughtbot.com/projects/shoulda) and testing in general. So, Chicago includes our Shoulda and Test::Unit macros and helpers.
[/excerpt]

So, why "Chicago"? Ever hear [this song](http://www.youtube.com/watch?v=77L57dKv64w)? Okay, but it gets cheesier. We're also from Chicago. Yeah ... we are. So it was only fitting.

## Runtime

### Macros

### Helpers

### Responders

### Under the Hood

Added `forward_sinatra_method` because Blake didn't :(

## Testing

### Shoulda

### Test::Unit
