# Rails 2: Inflection for Address

<cite>October 16th, 2008</cite>

[excerpt]
Hey! I added an ActiveRecord model to a project today named `Address`. It's exactly what you think it is and I want my Contacts in this project to have many addresses.

Because we're so hip and cool on this project, we're using Thoughbot's [Factory Girl](http://github.com/thoughtbot/factory_girl/tree/master) gem. Yeah. So, I ran my tests and BAM! got this error:

    1) Error:
        test: when something something something something "Address.count" from 1 to 0. (ContactTest):
        NameError: uninitialized constant Addres

[/excerpt]

Which can be traced to line 226 of Factory Girl's [factory.rb](http://github.com/thoughtbot/factory_girl/tree/master/lib/factory_girl/factory.rb) file, which does the following:

[code lang="ruby"]
if class_or_to_s.respond_to?(:to_sym)
  class_or_to_s.to_s.classify.constantize
else
  ...
[/code]

Seems simple enough to solve. Perhaps we should change the inflector rules to ... say ... this:

[code lang="ruby"]
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /(ss)$/i, '\1es'
  inflect.singular /(ss)es$/i, '\1'
end
[/code]

Yeah ... no! Still didn't work. Went out to eat. Came back. Tried this stupid, stupid, stupid thing and ... well ... it worked:

[code lang="ruby"]
ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular /(ss)$/i, '\1'
end
[/code]
 
Barf again!

Hopefully nothing else is broken now.