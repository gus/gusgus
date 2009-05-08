# Shoulda: Making DRY even DRY-ier

<cite>November 9th, 2008</cite>

[excerpt]
I'm in love with [Shoulda](http://thoughtbot.com/projects/shoulda). Not like that! Come on! I love Shoulda like a pedicurist loves sandpaper. My job would be do-able, but it would suck without it. My hands would be all crackly and stink a lot more. Not to mention I'd probably end up gouging the client and then hemorrhaging ... oh god!

Anyways, Shoulda takes some of the pain of writing tests away by actually making the tests readable. Contexts let me scope setup and teardown the way I've always wanted to. It's also very easy to generate `contexts` and `should` statements dynamically without all that `define_method` cruft.

Now, If I'm writing some sort of web-app - like with Rails or Sinatra - a lot of my model and controller tests tend to look the same. By the same, I mean there is an obvious pattern. Our refactoring brainwashing tells us we need to DRY this up. One obvious way of doing this is to write our own Shoulda macros by extending `Test::Unit::TestCase`, `ActionController::TestCase`, etc.
[/excerpt]

I prefer to extend/mix-into things by writing my own module with the methods I want and extending or including that module into the class/module the methods are intended for. Like so:

[code lang="ruby"]
module Thumblemonks
  module User
    module Shoulda

      def should_ask_for_milk_and_cookies
        # do someting
      end

    end # Shoulda
  end # User
end # Thumblemonks
Test::Unit::TestCase.extend(Thumblemonks::User::Shoulda)
[/code]

I like this approach because it's easy to find out - in like a debugger session - all of the modules that are mixed-in into a specific class/module that give said class/module it's methods. I like this approach every time, not just for extending things for Shoulda. *Props to [Dan Hodos](http://github.com/danhodos)*

Now, that being said, if I am going to add my own macros for a model test case (for instance), I do not like putting all of that code into the actual file containing the test case for the model. The standard approach I've seen is to then put it in the `test_helper.rb` file. I dislike this for two reasons:

1. It mentally restricts me from writing a lot of macros because it mucks up `test_helper`
2. `test_helper` should really just contain bootstrap code for all tests

Today, however I hit upon something I liked. I created a folder under `test` in my Rails app which I called ... wait for it ... `shoulda`. That's right, `$RAILS_HOME/test/shoulda`. Then, I did the following in my `test_helper.rb`:

[code lang="ruby"]
# including require_local_lib just because I use it everywhere
def require_local_lib(pattern)
  Dir.glob(File.join(File.dirname(__FILE__), pattern)).each {|f| require f }
end
require_local_lib('shoulda/*.rb')
[/code]

Then, I started creating a new file in shoulda - as I needed it - for each model I was testing. For instance, I was testing a `Membership` model and ended up creating `test/shoulda/membership.rb`. Seems simple, but I did sooooo much test refactoring in the process and my test cases ended up looking insanely clean and readable.

So, morals of the story are:

1. Use Shoulda, though you shoulda been doing it already ... [sad trombone](http://www.sadtrombone.com/)
2. Do break your shoulda macros into their own files
3. Keep shtuff out of `test_helper` that isn't helping bootstrap test cases
4. Refactor your tests mercilessly ... but, you already knew that
