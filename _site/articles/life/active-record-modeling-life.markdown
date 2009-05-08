# Active Record Modeling Life

<cite>January 18th, 2008</cite>

A quick observation I made about how `ActiveRecord` can be used to model life.

[code lang="ruby"]
class Life < ActiveRecord::Base
  has_many :causes
  has_many :effects, :through => :causes
end
[/code]
