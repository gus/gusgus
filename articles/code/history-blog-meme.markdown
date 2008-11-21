# History Blog Meme

<cite>November 12th, 2008</cite>

[excerpt]
As seen on [Joe O'Brien's](http://objo.com/) blog, a [history blog meme](http://objo.com/2008/4/19/history-blog-meme).

    justin@gus:~> history 1000 | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
    109 rake
    74 rakef
    52 cl
    48 hg
    40 git
    30 rakeu
    25 cd
    21 l
    15 ri
    11 erl

Proof that I run tests more than I do anything else; e.g. `rake`, `rakef` (`rake test:functionals`), and `rakeu` (`rake test:units`)!

Having found `Cmd+k` on my Mac, the `cl` (aka `clear`) call will stop.
[/excerpt]