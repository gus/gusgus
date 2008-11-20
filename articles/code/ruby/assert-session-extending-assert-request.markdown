# Assert Session - Extending Assert Request

<cite>January 8th, 2008</cite>

I was coding along in Rails with security in mind using the simple [Assert Request](http://validaterequest.rubyforge.org/) plugin from [Scott A Woods](http://workingwithrails.com/person/5938-scott-woods) in my controllers and ran into a spot where I wanted to require the presence of a session variable before allowing the rest of an action to execute. The specific motivation was conceived when coding a controller for an invitation mechanism. Normally, a user invites another user to a system, the invited user comes to the system with their invite-code (probably from a link in an email), completes some form (let's call it invite-accept), and then submits the final request (invite-update).

What I didn't want was an easy way for a user to be able to by-pass the invite-accept and go straight to invite-update. To prevent this, I wanted the invite-code to be available to invite-update, but not via a parameter. The quickest and safest way I could think was to require that it be in the session, which would theoretically force the user to first visit invite-accept. This way, only invited people can accept invites and they must go through invite-accept.

I also really liked the convention of using `assert_request` at the head of each of my actions (I even implemented an `assert_request_has_no_params` helper for most of them) and I didn't want to break from it to do a:

[code lang="ruby"]
def some_action
  raise Exception unless session[:invite_code]
  # ...
end
[/code]

## Interpretation

So, I wrote an extension to `AssertRequest` called - oddly enough - `AssertSession`. It's not complex and looks very similar to existing `AssertRequest` code. It currently supports two directives:

* **must_have** - Requires the existence of declared session variable(s) or an error is raised
* **may_have** - Allows for the existence of declared session variable(s)

The following code example shows how one might require the existence of three session variables for the given request: `:baz`, `:bum`, and `:bar`

[code lang="ruby"]
class FooController < ApplicationController
  def bar
    assert_session {|rule| rule.must_have :baz, :bum, :bar}
  end
end
[/code]

If any one of the session variables does not exist in the session at the time the request is processed, a `AssertRequest::RequestError` exception is raised with a meaningful error message; like:

[code lang="ruby"]
":baz and :bar expected to be in session"
[/code]

What if you only wanted to require `:baz`, but you wanted to allow for `:boo` and `:bar`?

[code lang="ruby"]
class FooController < ApplicationController
  def bar
    assert_session do |rule|
      rule.must_have :baz
      rule.may_have :boo, :bar
    end
  end
end
[/code]

For this example, an error will only be thrown if `:baz` is not defined at the time of the request. `:boo` and `:bar` may or may not be defined. This was useful for me to allow session variables that might have been stored during login actions, like a `return_to` *(though, in this case, it might be more prudent to allow a global ignore style declaration)*.

In addition, any variable found in the session that is not declared as a `must_have` or a `may_have` is considered malicious and a `AssertRequest::RequestError` exception is raised with a meaningful error message. For instance, given either of the above examples, the request will be halted and an error with the following message raised if a session variable is defined named `:toothrot`.

[code lang="ruby"]
":toothrot not expected to be in session"
[/code]

By default, `AssertSession` will ignore the variable named `flash` in the session.

`AssertSession` works right along `AssertRequest`, but cannot be called from within an `assert_request` block.

## Application

Back to the original motivation; the invitations controller. After having implemented `assert_session`, I was able to use it in the controller like so:

[code lang="ruby"]
class InvitesController < ApplicationController
  # ...
  def accept
    assert_request { |r| r.params.must_have :invite_code }
    @user = User.find_invited(params[:invite_code])
    session[:invite_code] = params[:invite_code]
  rescue ActiveRecord::RecordNotFound
    bad_request('The invite code you provided is invalid.')
  end

  def update
    assert_session { |s| s.must_have(:invite_code); s.may_have(:return_to) }
    assert_post do |r|
      r.params.must_have(:user) { |u| u.must_have(:name, :password,
        :password_confirmation)}
    end
    # ...
  end
end
[/code]

The `:return_to` should really only be present if you've ever tried to login, but since I do a lot of playing in the interface, I would routinely hit the problem where `:return_to` existed and I didn't really feel like clearing my sessions (`:return_to` comes with `acts_as_authenticated`).

`assert_post` is another helper I wrote which simply does an `assert_request`, requires the method to be a POST, and then yields. Like this:

[code lang="ruby"]
def assert_post(&block)
  assert_request do |rules|
    rules.method :post
    yield rules
  end
end
[/code]

A cooler approach would be if `assert_request` itself was modified to accept the required HTTP method as an argument. An example of use would be:

[code lang="ruby"]
assert_request(:post) {...} # What do you think, Scott?
[/code]

## Installation

First, install the `AssertRequest` plugin.

[code lang="ruby"]
ruby script/plugin install svn://rubyforge.org/var/svn/validaterequest/plugins/assert_request
[/code]

Second, create a file using the code below in your Rails application and require it in your `environment.rb` file. When Scott Woods accepts the patch, you can simply install/update the plugin you have installed.

## Code

Until Scott Woods adds the code into the plugin, the code only exists here.

[code lang="ruby"]
module Glomp #:nodoc:
  module AssertRequest #:nodoc:
    module PublicMethods #:nodoc:
      def assert_session
        rules = SessionRules.new
        yield rules
        rules.validate(session)
      end
    end # PublicMethods
  
    class SessionRules
      def initialize
        @required = []
        @ignore_vars = ['flash']
      end

      def must_have(*args)
        @required.concat(args).flatten!
        self
      end

      def may_have(*args)
        @ignore_vars.concat(args).flatten!
        self
      end

      def validate(session)
        cats = {:expected => [], :unexpected => [], :matched => []}
        session.data.each do |k,v|
          cat = @required.index(k) ? (!v ? :expected : :matched) : :unexpected
          cats[cat] << k
        end
        cats[:expected] += @required - cats[:matched]
        if !cats[:expected].empty?
          raise ::AssertRequest::RequestError,
            "#{cats[:expected].to_sentence} expected to be in session"
        elsif !(cats[:unexpected] -= @ignore_vars).empty?
          raise ::AssertRequest::RequestError,
            "#{cats[:unexpected].to_sentence} not expected to be in session"
        end
      end
    end
  
  end # AssertRequest
end # Glomp

ActionController::Base.send(:include, Glomp::AssertRequest::PublicMethods)
[/code]

Tests are available upon request.