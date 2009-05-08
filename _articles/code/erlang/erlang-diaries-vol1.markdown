# Erlang Diaries: Vol 1 - Brought to you by the lower-case letter 'c'

<cite>November 12th, 2008</cite>

[excerpt]
I'm starting a new diary for my forays into learning Erlang. Below are my first entries. I basically want to learn Erlang for a couple of reasons:

* It's a new language I don't know
* Functional languages interest me
* I enjoy agent-based modeling and simulation
* I want to write a Wator simulation in Erlang

The reason for the final note can be traced back to a [Software Craftsmanship](http://groups.softwarecraftsmanship.org/) meeting on November 10, 2008. Uncle Bob was talking about the *Total Cost of a Mess* and showing off his old Java crapplet code for a Wator implementation. Dean Wampler then said, and I'm paraphrasing, it would be interesting [for Gus] to implement Wator in Erlang.

[/excerpt]

### 11/11 @ 12:00

Some tests were running while I was at work so I installed the Erlang Mac port. The install didn't work :( I had to modify the port to remove the `- hipe` line. Thanks to [Brian Tatnall](http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/).

I also downloaded some documentation. Namely:

* Erlang Book - Part 1; [EB]
* Design Patterns for Simulations in Erlang/OTP; [PhD]
* Program Development Using Erlang - 
Programming Rules and Conventions, from Ericsson; [Zzzz]
* HTML Documentation provided with the port, same as on the site; [erl]

I haven't written or compiled a lick of code yet, haven't even really looked at the language. I know from past experiences that getting started is the slowest part of learning a language and that having documentation at your fingertips is the key to resolving it.

See you later. Love you. *Golly ... I sure am excited*

### 11/12 @ 8:10

I didn't get much sleep last night. Nothing to do with Erlang. I hit snooze like 3 or 4 times. I was already running late and sent an email to the team about it. Apparently my son had the same problem. I had to drive him to school, which made me late for my late train.

Thusly, I had about 50 minutes to spare before the 8:55a train, which you know is not going to get there on time because American train systems suck and never get anywhere when they're supposed to; unless I'm running almost late and get to the train a few minutes ahead only to find that that the smart train conductors were thinking kindly and got the train there ahead of me.

All that said, time to spare. I "opened" [EB] and read through the Introduction. I really did this time. I'll prove it: Erlang was designed for use in concurrent, real-time systems. It was designed pragmatically while some phone geeks were putting together a phone system. The language only contains what is needed and it doesn't contain any of that gobbelty-gook sugar that sequential logic programming languages have. And it's fast.

Next, I started chapter 1 entitled *Programming*. Awwweeesuuummm. First page, code; to wit:

    -module(math1).
    -export([factorial/1]).

    factorial(0) -> 1;
    factorial(N) -> N * factorial(N-1).

I can type that into my editor, and did (actually, I copied it). Saved it as `ch1.erl`. I added the `erl` because I noticed there was a command of the same name and I figured I would be smart. `ch1` means "chapter 1". Oh, you betcha \*wink\*.

Alright. Now to run it.

Ok.

Want to run it.

Looking around for the next step; the running-it step.

Still looking.

[EB], help! Anything? What's that you say [EB]?

> [EB]: How the code for factorial was compiled and loaded into the Erlang system is a local issue.

> Gus: WTF does that mean?

> [EB]: By ‘local issue’ we mean that the details of how a particular operation is performed is system-dependent and is not covered in this book.

> Gus: Uh huh ...

*[EB; page 10]*

Well ... that's not very helpful. What the hell is NOT system-dependent? Diary, Erlang made me so mad! I could have just poked it in the eye; but not too hard.

I hacked around for while, farting with `erl`. Got a lot of this:

    ** exception error: bad argument in an arithmetic expression
         in operator  '/'/2
            called as factorial / 1

and this:

    > import('./ch1').
    exception exit: {{bad_module_name,"./ch1"},[{shell,import,1}]}

and this:

    > module(math1).
    ** exception error: undefined function shell_default:module/1

and this

    > import(ch1).
    ok
    > math1:factorial(1).
    ** exception error: undefined function math1:factorial/1

Doh! That last one with the `ok` really got me. I swear to god I thought I had it. [Khhhhaaaaannnnnnn](http://www.youtube.com/watch?v=UJTi7KJPx_E)!

Tried compiling with `erlc`. It created a file called `ch1.beam`. But ... didn't help. Don't know what to do with it and I have no stinking internet access because I'm still at the train station and I don't have one of those cool cards that lets me connect over satellite or cellular signals. Wah!

I have over 300 pages of documentation on Erlang. No lie. Where is the little bit of documentation that says, *"If you'd like to actually use this turd you just wrote, do this you big dumby ..."*? Or maybe *"If on a machine that is inferior to one of the real-time embedded systems we wrote this language for, do this ..."*. Seriously! Is it truly that terrible? Does it make the documentation that is linked off the site so muddied up and offend so many of others' sensibilities? I think not.

Gobbelty-gook sugar sure would be *sweet* right now :( If I ever get something running and then learn this language, I will feel soooooo elite .. barf.

Done for now. Crying. I'm sad and it's cold outside.

### 11/12 @ 9:58

Almost to the train station. Had a thought:

> Note: When [Gabriel](http://annealer.org) said he didn't like Erlang because of the syntax, what was I thinking about? Probably had something to do with unicorns, band-aids, and rock candy.

### 11/12 @ 19:42

Diary,

I finally got Erlang to compile something. It was our little factorial program and I did it on the way home today ... on the train not in the car. It all started when I did some digging into the docs that can be found with the port and ran across "Getting Started With Erlang" [GS]. With an unlikely name like that, it's no wonder I couldn't figure it out.

Anyways, seems like I was almost there. I was missing one f'ing character in this whole mess. The lower-case letter 'c'. What does it do? Well, look at this:

    justin@gus ~ > erl
    Erlang (BEAM) emulator version 5.6.2 [source] [async-threads:0] [kernel-poll:false]

    Eshell V5.6.2  (abort with ^G)
    1> c(math1).
    {ok,math1}
    2> math1:factorial(1).
    1
    3> math1:factorial(10).
    3628800
    4> math1:factorial(100).
    93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000

Yeah, it worked. I'm happy again.

Look! A unicorn with a band-aid on its corn and it's crapping rock candy throughout the land.

Love you! Ok, ba bye.

PS: I added a great picture.

<img src="/images/articles/code/erlang/erlang-vol1-unicorn-bandaid.jpg">