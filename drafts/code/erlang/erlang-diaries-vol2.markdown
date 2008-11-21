# Erlang Diaries: Vol 2 - something something something

<cite>SOME FUTURE DATE</cite>

### 11/13 @ 00:45

Dear Diary,

Discovered that Erlang is much like Ocaml. Why? Well I was for fun implementing a tail-recursive, list-length calculator and I just threw in an underscore (\_) as part of the arity contract for a function to indicate that I don't care what kind of value is there, just match anything (anonymous variable as they say).

Didn't even have to look it up, I just typed it and it happened to work.

    -module(math1).
    -export([list_length/1]).

    list_length(List) -> list_length(0, List).

    list_length(Acc, []) -> Acc;
    list_length(Acc, [_|Rest]) -> list_lengthst_length(Acc + 1, Rest).

Of course, all of the warnings that were coming from good ol' `erl` were making me want to type it. Crazy uncle `erl`!

Oh Erlang. Oh Ocaml. So dreamy? You care not for what don't need to want to.

---

By the way, did you know you can't use your own functions in guard clauses? [EB] says to the advanced readers:

> [EB] Aside for advanced readers: This is to ensure that guards don't have side effects

Ugh, the clause itself *is* a side effect! I mean, OMG.

---

Yeah! Erlang is fun because Erlang has fun().

### 11/13 @ 1:15

Erlang TextMate bundle:

  > cd ~/Library/Application\ Support/TextMate/Bundles
  > svn --username anon --password anon co http://macromates.com/svn/Bundles/trunk/Bundles/Erlang.tmbundle/
  > osascript -e 'tell app "TextMate" to reload bundles'

---

Concurrency! I mean ... Processes!

    Ping ! Pong
