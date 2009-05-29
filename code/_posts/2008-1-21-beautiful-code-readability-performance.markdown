---
layout: post
title: Readability and Performance is Beautiful Code
summary: Thoughts on what makes code beautiful
---

Had a *nice* email discussion amongst the [Centronians](http://techni.cal.ly) the other day about what beautiful code is. The discussion came about due to a challenge I put out to the team to improve a certain nested conditional branch in the [Identity Matcher](http://identity-matcher.googlecode.com/svn/trunk/lib/identity_matcher.rb) method, `match_foaf`.

Seems as though there are some strong opinions from some that readability of code is secondary to the performance of code. I figured I would some up my thoughts and did so in the following matrix:

<img src="/images/articles/code/code-perf-read.png">

To be clear, this is the code in question:

{% highlight ruby %}
if foaf.has_key? '<>'
  knows = foaf['<>']["<http://xmlns.com/foaf/0.1/knows>"]
  if !knows.nil?
    knows.each do |know|
      if foaf.has_key? know
        person_id = foaf[know]["<http://xmlns.com/foaf/0.1/Person>"]
        if !person_id.nil? and person_id.size > 0
          person = foaf[person_id[0]]
          if !person['<http://xmlns.com/foaf/0.1/nick>'].nil? and person['<http://xmlns.com/foaf/0.1/nick>'].size > 0
            nicks << person['<http://xmlns.com/foaf/0.1/nick>'][0]
          end
          if !person['<http://xmlns.com/foaf/0.1/member_name>'].nil? and person['<http://xmlns.com/foaf/0.1/member_name>'].size > 0
            names << person['<http://xmlns.com/foaf/0.1/member_name>'][0]
          end
        end
      end
    end
  end
end
{% endhighlight %}

Keep an eye on [Slick or Slack](http://slickorslack.com) for this little piece of code I threw up [there](http://slickorslack.com/codes/100). If my assumption is right, it will be one of the slackest of all.

## Update

1. Slick or Slack no longer exists :(
