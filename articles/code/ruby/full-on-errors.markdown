# Rails Plugin: Full on Errors

<cite>December 21st, 2007</cite>

ActiveRecord's `full\_messages` method is a useful one for many reasons. I like using it as a message for tests that fail for strange reasons. I like it for displaying error messages in a view, which is simpler than modifying how `error\_messages\_for` displays. However, I have always found it annoying that I cannot ask an `ActiveRecord` object for the full-messages on a specific attribute ... until now.

To remedy this, I wrote the **`full\_on\_errors`** plugin which simply adds a `full\_on` method to the `Errors` class of an `ActiveRecord` instance. It's use is simple; simply call `full_on` and pass the attribute for which you would like the full messages for.

## Example

In fact, it's so simple that examples are coming in the third paragraph. Let's say you have a User model that looks like the following:
[code lang="ruby"]
class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :email
end
[/code]

Ignoring the fact that you could one-line the validation, if you were to validate a new instance of User that does not provide `name` or `email`, you would receive two error messages. With *`full\_messages`*, what would return would look like the following:

[code lang="ruby"]
user = User.new
user.valid?
=> false
user.errors.full_messages
=> ["Name can't be blank", "Email can't be blank"]
[/code]

But, what if you wanted the full-messages for just the `name` attribute? You could look for those errors that start with name; you could live with `user.errors.on(:name)` returning an array of partial error message; or you could do the following:

[code lang="ruby"]
user = User.new
user.valid?
=> false
user.errors.full_on(:name)
=> ["Name can't be blank"]
[/code]

## Installation

*Step 1:* install the Rails plugin:

[code lang="plaintext"]
$RAILS_ROOT> ./script/plugin install \
  http://glomp.rubyforge.org/svn/plugins/full_on_errors
[/code]

*Step 2:* Start using it

## Code

The code is extremely simple and is - oddly enough - based on `Errors.full\_messages`. I have simplified the `full\_messages` code to focus on one attribute, to do less, and to look better (according to Gus Aesthetics):

[code lang="ruby"]
module Glomp #:nodoc:
  module FullOnErrors #:nodoc:
    def full_on(attr_name)
      attr = attr_name.to_s
      errs = on(attr).to_a
      return errs if attr == 'base'
      human_name = @base.class.human_attribute_name(attr)
      errs.map {|msg| "#{human_name} #{msg}"}
    end
  end # FullOnErrors
end # Glomp

ActiveRecord::Errors.send(:include, Glomp::FullOnErrors)
[/code]

For comparison's sake, here is the `full\_messages` code from the Errors class:

[code lang="ruby"]
# Returns all the full error messages in an array.
def full_messages
  full_messages = []

  @errors.each_key do |attr|
    @errors[attr].each do |msg|
      next if msg.nil?

      if attr == "base"
        full_messages << msg
      else
        full_messages << @base.class.human_attribute_name(attr) + " " + msg
      end
    end
  end
  full_messages
end
[/code]
