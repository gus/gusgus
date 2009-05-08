# Load Model - ActionController Extension to Automatically Load Model Instances

<cite>January 3rd, 2009</cite>

[excerpt]
> *[Load Model](http://github.com/thumblemonks/load_model) can be found on Git Hub :)*

This post is a long time in coming. I've pretty much procrastinated on writing it for about a year and I'm not even sure why. Only after reading the [RoR Security Book](http://www.rorsecurity.info/storage/rails_security_2.pdf) today - and specifically the section on *Privilege Escalation* - did I feel compelled and obligated to write about a Rails plugin turned gem that I wrote a year ago.

Behold, [Load Model](http://github.com/thumblemonks/load_model).

It's not going to cook you breakfast in the morning, but it is going to make your job easier for something you probably do all the time in your controllers. Load Model basically provides a concise macro - a glorified `before_filter` - for finding and loading a model object based on one of the request parameters and setting it to an instance variable. Load Model will do this almost automatically so long as you are following a restful convention in your controllers.

For instance:

[code lang="ruby"]
class PeopleController < ApplicationController
  load_model :person
end
[/code]

The above code will look for a parameter named `:id` and use that to find a `Person`. If `:id` is provided and a `Person` record is found (via a call like `Person.find_by_id(params[:id])`), the record instance will be set to the `@person` instance variable. It's that easy.

It's essentially the same as saying:

[code lang="ruby"]
class PeopleController < ApplicationController
  before_filter :load_person
private
  def load_person
    @person = Person.find_by_id(params[:id])
  end
end
[/code]

But wait, there's waaaaayyyyy more! Including an easy approach to dealing with the privilege escalation use case.
[/excerpt]

### Waaaaayyyyy More

If everything were as simple as shown in the example above, I probably would not have needed to write Load Model. (Un)Fortunately not everything is so simple.

Here's a quick peek at all the options. Most of these are named the way they are to indicate how closely Load Model is tied to Active Record.

* `:class` - An alternative class name to load the model from. Defaults to the singular name of the provided model name. Same thing as `:class_name` for associations.
* `:parameter_key` - The key in the params hash to use to grab the lookup value from. Does not support nesting. Defaults to `:id`.
* `:foreign_key` - Used as the column name/lookup key on the association. Defaults to `:id`.
* `:require` - Tells Load Model to throw an error if no record was found. Defaults to `false`.
* `:except` - Load Model will not execute when the actions listed in this array are invoked.
* `:only` - Load Model will only execute when the actions listed in this array are invoked. `:except` has precedence over `:only`.
* `:through` - Tells Load Model to use an instance variable to load a record from instead of from the association class. `:through` takes precedence over `:class`.

Following are the bulk of the use-cases for using Load Model and how to use it appropriately.

## Privilege Escalation

I'm not going to wait around. I'm going to jump to straight into privilege escalation and blow the whole enchilada right now. There's no point in building you up to this. You're smart! People like you! And anyways, it may be the only reason you've read this far.

Let's say you have a nested resource; like Images which nests under People. You're routes and Image controller may look like this:

[code lang="ruby"]
# Routes

ActionController::Routing::Routes.draw do |map|
  map.resources :people do |people|
    people.resources :images
  end
end

# Images controller

class ImagesController < ApplicationController
  # Oh boy, some code!
end
[/code]

Now, when someone wants to see an image for a specific person, a typical URL would look something like:

    http://example.com/people/1/images/3

You don't want some stranger just changing that 3 to some other integer and getting a peek at another user's bottle-cap collection photos. So, you only want to limit the set of photos that are searchable to the specified user's (who has an id of 1).

With Load Model you can do this in two lines and it will work for all actions of the Images controller.

[code lang="ruby"]
class ImagesController < ApplicationController
  load_model :person, :parameter_key => :person_id
  load_model :image, :through => :person
end
[/code]

Yes, order of macro definition does matter. And yes, `:through => :person` assumes there will be an instance variable named `@person` for Load Model to find the image from. In this case, Load Model will do the following at run time:

[code lang="ruby"]
@image = @person.images.find_by_image_id(params[:id])
[/code]

What's that you say? You only want to load images for actions that will actually provide the `:id`? Oh, okay.

[code lang="ruby"]
class ImagesController < ApplicationController
  load_model :person, :parameter_key => :person_id
  load_model :image, :through => :person, :only => [:show, :edit, :update, :destroy]
end
[/code]

What? You don't want to do anything unless you find the Person instance first and you want to bail out if no image is found? Well ... fine!

[code lang="ruby"]
class ImagesController < ApplicationController
  load_model :person, :parameter_key => :person_id, :require => true
  load_model :image, :through => :person, :require => true, :only => [:show, :edit, :update, :destroy]
end
[/code]

Notice the addition of the `:require` options.

I think you get the point. In fact, that's how we at Thumble Monks do it and how Load Model wants you to do it.

If you add the following to your `ApplicationController`, you can handle the case when a required record is not found by Load Model or any other action/filter (when `:require => true`):

[code lang="ruby"]
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
private
  def record_not_found(exception)
    log_error(exception)
    flash[:error] = "Unexpected error handling your request"
    redirect_to your_default_controller_url
  end
end
[/code]

### Advanced

I bet you didn't think it could get more advanced. You were wrong.

Let's say you have a Communities resource, which has a nested Events resource, which has a nested Attendees resource. Oh boy! The route definition would look something like:

[code lang="ruby"]
ActionController::Routing::Routes.draw do |map|
  map.resources :communities do |communities|
    communities.resources :events do |events|
      events.resources :attendees
    end
  end
end
[/code]

The URL would probably look like the following when doing something with a specific attendee:

    http://example.com/communities/1/events/3/attendees/5

Let's also assume you require users to login and when logged in, you set an instance variable called `@current_person`. Here's how you could setup your Attendees controller to only find attendees of events of communities that the logged-in user has access to:

[code lang="ruby"]
class AttendeesController < ApplicationController
  load_model :community, :through => :current_person, :require => true,
    :parameter_key => :community_id
  load_model :event, :through => :community, :require => true,
    :parameter_key => :event_id
  load_model :attendee, :through => :event, :require => true, :only => [:show, :edit, :update, :destroy]
end
[/code]

Yes it works and yes we are using this recipe. I have some ideas for how to make this even more concise/automatic, just haven't gotten around to implementing them yet. As you can imagine, there is a pattern.

For example, it would be a lot cooler if I could do this:

[code lang="ruby"]
class AttendeesController < ApplicationController
  load_model :attendee, :through => { :event => {:community => :current_person} },
    :require => true, :only => [:show, :edit, :update, :destroy]
end
[/code]

Load Model could also just assume that `:show, :edit, :update, :destroy` will get an `:id` by default.

## Yeah, but my association is not found with the :id key

Perhaps you want to find a record using a lookup key/column name other than `:id`? To have an example to work from, let's say you deal with invitations and in the URL the invitee clicks from their email a UUID value is used in place of the `:id`. The UUID value will likely be stored as a column on Invites named, oddly, `:uuid`. The URL in the email would probably look like this:

    http://example.com/invites/550e8400-e29b-41d4-a716-446655440000

With Load Model, you would load up this invite like so:

[code lang="ruby"]
class InvitesController < ApplicationController
  load_model :invite, :foreign_key => :uuid
end
[/code]

This is the equivalent to doing the following in your actions:

[code lang="ruby"]
@invite = Invite.find_by_uuid(params[:id])
[/code]

All of the other options still work; like: `:require`, `:only`, etc.

## Except, I just want to exclude some actions from Load Model

You may not like to use the `:only` option for being explicit about the actions that need model loading. Maybe you have a whole bunch of actions in your morally bankrupt controller and it would be crazy to try and include them all. Fine. Load Model provides the `:exclude` option.

Here is an example that excludes actions that would not need to accept the :id parameter.

[code lang="ruby"]
class ImagesController < ApplicationController
  load_model :image, :except => [:index, :new, :create]
end
[/code]

It should be noted that since we're not using the :require option, we're saying more than we need to. But, that's why this is an example.

## Of a different class

Finally, and probably least common, is the case when you want to load a record into an instance variable, but the class/model name for loading the record from cannot be inferred. For these cases, you use the `:class` option and provide the class name that should be used.

Example, and this one is way contrived at the moment, you want to load a user account in an Admin controller and you want to call the instance variable `@admin`. You would simply do the following in Load Model:

[code lang="ruby"]
class ImagesController < ApplicationController
  load_model :admin, :class => 'User', :require => true
end
[/code]

I threw the `:require => true` since it's the administration controller ;)

## What else?

Please let me know if there are any obvious enhancements that can be made or if we're just being dumb about something. I've never really seen anything quite like Load Model and I made sure I was **NOT** reinventing the wheel here. I mean, I tried real hard not to.

See the [Readme](http://github.com/thumblemonks/load_model) on GitHub for notes on installation, licensing, and so forth.
