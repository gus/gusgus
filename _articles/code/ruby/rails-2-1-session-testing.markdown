# Session Testing in Rails 2

<cite>August 19th, 2008</cite>

[excerpt]
I upgraded one of my Rails apps recently from Rails pre 2.1 to Rails 2.1. I had a couple of expected caveats that needed my attention; like:

* I was able to remove the use of my [Flashback](/2008/1/18/flashback-to-flash-now) plugin because `Flash.now` became testable
* I was able to use named\_scope instead of has\_finder
* et al

However, there was one little hitch in my tests that I was not expecting. One of my controller tests was adding a session variable and the controller was looking for that value. Problem was, it kept failing. But ... it used to pass.
[/excerpt]

Here's what my test code did look like:

[code lang="ruby"]
def test_update_should_clear_invite_code_from_session_on_success
  @request.session[:invite_code] = invite_code
  post :update, ...
  assert_nil session[:invite_code]
end
[/code]

And then I was using it with my [AssertSession](/2008/1/9/assertsession) plugin that I'm waiting for [Scott Woods](http://workingwithrails.com/person/5938-scott-woods) to add into [AssertRequest](http://validaterequest.rubyforge.org/) (since he emailed me that he would ... ahem):

[code lang="ruby"]
def update
  assert_session {|s| s.must_have(:invite_code); ... }
  ...
  @user = User.find_invited(session[:invite_code])
  ...
end
[/code]

Notice here that the reference to `invite_code` is a symbol. As long I only try to access `invite_code` using `Session`'s square-bracket method (`def \[\]\(key\)`) ... then no problems; thanks to `HashWithIndifferentAccess`. My `AssertSession` plugin, however accesses `Session`'s `data` function. It seems that `Session` (or maybe just `TestSession`) has turned all keys to strings. Thus, `AssertSession` cannot match a symbol to a string.

Well okay. I switched every one of the session keys to strings and - sadly - my tests are passing. Ho hum.

For clarity's sake, here is the new code:

[code lang="ruby"]
def test_update_should_clear_invite_code_from_session_on_success
  @request.session["invite_code"] = invite_code
  post :update, ...
  assert_nil session["invite_code"]
end
[/code]

[code lang="ruby"]
def update
  assert_session {|s| s.must_have("invite_code"); ... }
  ...
  @user = User.find_invited(session["invite_code"])
  ...
end
[/code]