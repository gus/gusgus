---
layout: post
title: Flashback
summary: Test your flash and I mean .now
---

#### Update

* This is old news. Rails 2.x makes this a moot point.

---

I love the `Flash.now` mechanism. I love it with a weird passion. It really lets me DRY up my views in regards to message handling, while also allowing me to keep my controller code straight forward. I basically have one way to handle messages and all I have to do is add a `.now` to my `flash` reference when I don't want to do a redirect.

But ... there's always a but ... I also love tests. I love tests with an even weirder passion than I love `Flash.now`. And if you know anything about `Flash.now` and Rails tests, then you know where I'm going with this; I can't test `Flash.now` variables in my functional tests!

You say, *"Say what?!"*

I say, *"It's true."*

You say, *"Yeah, I know. It's also sad."* But wait, there's the article called [How to test flash.now](http://wiki.rubyonrails.org/rails/pages/HowToTestFlash.Now).

I say, *"Yeah, but that's dumb."* Why should I have to test a seemingly isomorphic mechanism in two different ways?

You might say, *"Because Flash.now basically discards variables passed into it so that at the end of the request, the get swept-up by the chain of sweepers."* 

I **know** I would say, "True. But I don't really care. These are tests." And anyways, I hate, hate, hate using `assert_tag` in functional tests. Save it for integration tests.

Finally, I would say, *"I wrote this fancy plugin called Flashback which solves my problem."*

You say, *"Oh."*

## Interpretation

`Flashback` is four useful lines of magic and wonder rolled into a big ball of **plugin**. I went through many iterations in my head for how I wanted to implement it, but I went with the following for my objectives:

 1. The solution should only have effect in tests. It should not implicitly weave its way into production behavior.
 2. I should be conscious when the behavior is in affect.
 3. It should require very little effort on my part to enable the feature
 4. It should be simple

With that in mind, I hit the court and started playing. Of course, I knew it was going to be a plugin, so I just went ahead and created the plugin. Being a tester, I wrote several functional tests for how I wanted it to work. They looked something like this:

{% highlight ruby %}
class FlashersControllerTest < ActionController::TestCase
  def test_flash_available_after_request
    get :index, :actual_flash => 'hello'
    assert_equal 'hello', flash[:actual_flash]
  end

  def test_flash_now_not_available_after_request
    get :index, :actual_flash_now => 'world'
    assert_nil flash.now[:actual_flash_now]
  end

  def test_flash_now_is_available_after_request_via_flashed
    get :index, :actual_flash_now => 'world'
    assert_equal 'world', flash.flashed[:actual_flash_now]
  end
end
{% endhighlight %}

Three erroring tests. Oh, joy! I love errors when they come immediately after writing my test code. Notice the `flashed` method call in test 3. That's my contribution to the world of `Flash`. I want it to mean, give me the variables that were flashed (or flushed) during the request. Like a flash of light; fizzled and forgotten.

Guess I should implement the faux Controller:

{% highlight ruby %}
class FlashersController < ApplicationController
  def index
    flash[:actual_flash] = params[:actual_flash]
    flash.now[:actual_flash_now] = params[:actual_flash_now]
    render :text => 'blah'
  end
end
{% endhighlight %}

Two passing tests, and an erroring test. Yippee! Just need to make that `flashed` do something. Here, I went through many, many trials and tribulations. For like, almost 30 minutes. That is, until I figured, *"Why not just insert my own Flash hash into the session for the request?"* Like so:

{% highlight ruby %}
class FlashedHash < ActionController::Flash::FlashHash
  def flashed
    @flashed ||= {}
  end

  def discard(k=nil)
    flashed[k] = self[k]
    super(k)
  end
end
{% endhighlight %}

Hmmm ... and to accomplish objective (2), I would need to set that up somehow. Objective (3) says it should be easy to use. So, I settled on a little method that would be available in `Test::Unit::TestCase`, that is dependent on there being a `TestRequest` instance assigned to a `@request` instance variable (which there always is for functional tests), and that would be named ... `flashback`.

{% highlight ruby %}
def flashback
  @request.session['flash'] = FlashedHash.new
end
{% endhighlight %}

This, however, required a drastic change in my test; which went from two lines, to three.

{% highlight shell %}
def test_flash_now_is_available_after_request_via_flashed
  flashback
  get :index, :actual_flash_now => 'world'
  assert_equal 'world', flash.flashed[:actual_flash_now]
end
{% endhighlight %}

And, I had to write another test to be sure that `flashed` was not available when `flashback` wasn't called:

{% highlight ruby %}
def test_no_flashback_means_flash_now_not_available_after_request_via_flashed
  get :index, :actual_flash_now => 'world'
  assert_raise(NoMethodError) {flash.flashed[:actual_flash_now]}
end
{% endhighlight %}

I wrote a couple of other tests, but you get the point. Call `flashback` before you test your action and after `@request` is defined, and Bob's your uncle!

## Application

You might not believe this, but I had an actual use for this little plugin immediately after writing it. In a certain Rails application I am working on, I have controllers with actions that render a page when an error occurs.

*"Amazing"*, you say.

It's the standard `new -> create` or `edit -> update` paradigm. When an error occurs in the create/update actions, I put errors in the flash.now hash as ... can you guess it ... `:errors`. Whenever `flash[:errors]` exists while rendering a view, I do something special with it; like display it ... *"Oooooooooo"*, say the martians.

So, I want to test my `flash.now` variables. I like the idea of setting `flashback` when I need it, versus all the time with a `setup`.

Here's the first place I used it; an action for creating `Stickies`, which are kind of like user-to-user comments, but different ... sort of.

{% highlight ruby %}
def test_create_should_flash_error_on_failure
  user = users(:quentin)
  sticker = users(:aaron)
  login_as(sticker)
  flashback
  post :create, :user_id => user.id, :sticky => {:message => 'blah'}
  assert_match /Problems .+ Sticky/, flash.flashed[:error]
end
{% endhighlight %}

Here's what the important part of create looks like in the controller:

{% highlight ruby %}
class StickiesController < ApplicationController
  def create
    # ...
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = "Problems erupted while saving the Sticky"
    render :action => 'new'
  end
end
{% endhighlight %}

## Installation

Simple and easy:

{% highlight shell %}
ruby script/plugin install http://glomp.rubyforge.org/svn/plugins/flashback
{% endhighlight %}

[Documentation](http://glomp.rubyforge.org/flashback) is served from [RubyForge](http://rubyforge.org/projects/glomp), just like the plugin itself.
