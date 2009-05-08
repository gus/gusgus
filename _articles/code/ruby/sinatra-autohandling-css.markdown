# Sinatra: auto-handling any CSS

<cite>August 28th, 2008</cite>

<img src="http://bowjamesbow.ca/images/fight-club.jpg" align="right">

[excerpt]
My [buddy](http://annealer.org) and I like .. no, love ... [Fight Club](http://www.imdb.com/title/tt0137523/); more the movie than the book. We can't help but quote it like ... all the damn time. We'll even use the quotes to express ourselves; especially those that start with *"I am Jack's ..."*

So, we thought it would be a good idea to start a site called [I am Jack's](http://iamjacks.org) to allow us and others to go this site and enter their phrases for the moment. We also figured it would be neat to watch Twitter's public timeline for such statements and report on them.

But, that's NOT the point of this article. The point of this article is to highlight a little thing we did while implementing the site. See, we normally do stuff in Rails because, well, it's pretty easy. However, we wanted to do something new and do something simple.
[/excerpt]

### Sinatra

Talk about simple. [Sinatra](http://sinatrarb.com) rocks. But, that's still not the point of this article. The point of this article is to highlight this little thing. Remember?

The little thing, and I do mean little, was to add a handler for CSS that can handle any stylesheet request. See, most of the examples for handling CSS in Sinatra look like this:

[code lang="ruby"]
get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end
[/code]

Or, they render the CSS directly in the app.

I. Don't. Like. That.

I want all my view related code in one place and I know that all my CSS will be handled the same way. In my app, I want to do this:

[code lang="ruby"]require 'sinatra'

catch_all_css

# handle everything else
[/code]

Which should run any resource that matches `*.css` through a Sass builder. Easy peasy:

[code lang="ruby"]
def catch_all_css
  get '/*.css' do
    header 'Content-Type' => 'text/css; charset=utf-8'
    sass request.env["PATH_INFO"].match(%r[\/(.+)\.css])[1].to_sym
  end
end
[/code]

Yep; it works. But, this solution only works well when the stylesheet is requested off the doc-root. If you want to handle `/stylesheets/*.css`, you'll just have to modify the regular expression a little or get it through URI.

### Possible changes

You may not want to use Sass. Why you wouldn't want to I don't understand, but you just may not want to. Here is a possible modification to the above that may work.

[code lang="ruby"]require 'sinatra'

catch_all_css(:sass)
[/code]

[code lang="ruby"]
def catch_all_css(handler=:render)
  get '/*.css' do
    header 'Content-Type' => 'text/css; charset=utf-8'
    resource = request.env["PATH_INFO"].match(%r[\/(.+)\.css])[1].to_sym
    self.send(handler, resource)
  end
end
[/code]

### Something I've Heard

I've [heard](http://www.gittr.com/index.php/archive/sinatra-splat-routes/) that a future version of Sinatra will allow me to get the value of the splats (the values matched by the asterisks of a route) from `params['splats']`. If this is true, we could modify `catch\_all\_css` to look like this:

[code lang="ruby"]
get('/*.css') { sass params["splat"].first.to_sym }
[/code]
