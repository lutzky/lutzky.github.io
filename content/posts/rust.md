---
title: "I tried Rust"
date: 2023-01-16T15:34:25Z
slug: rust
aliases: ["/2023/01/16/rust/"]
tags: ["software", "go", "rust"]
subtitle: "...and now I hate all other programming languages."
summary: >
    ...and now I hate all other programming languages. The lament of a regular
    Go user.
draft: false
---

## It's December 2022, let's try Rust 🦀

As you can tell by previous posts on this blog, I used to be quite a fan of Go;
I use it at work often, and some features about it are legitimately great:
Package management, "static duck typing" (structural typing), providing
interfaces while stepping away from inheritance, all quite nice (and present in
Rust). I wasn't too unhappy with the repetitive error handling, generics are
finally coming into play, and nothing I write is anywhere near
performance-critical enough for me to care about GC overhead (though I did
glance firmly at the binary size once in a while). But come December, as I
decided to give [Advent of Code][aoc] a go this year, I figured I'd try to use
it to learn a new language: Rust.

[aoc]: https://adventofcode.com

Now, Rust has been steadily gaining popularity for a while, but two recent
events caused me to pay attention: In September, a CTO from Microsoft gave Rust
a [significant endorsement][theregister-in-rust-we-trust]. In that same month,
Linus Torvalds effectively announced that [Rust was coming to the Linux
kernel][zdnet-rust-linux]. When those two agree on something, I figured, it's
probably worth paying attention.

[theregister-in-rust-we-trust]: https://www.theregister.com/2022/09/20/rust_microsoft_c/
[zdnet-rust-linux]: https://www.zdnet.com/article/linus-torvalds-rust-will-go-into-linux-6-1/

To my delight, someone else --- [fasterthanlime] --- was doing Advent of Code in
Rust. In fact, he was doing a day-by-day ["let's learn rust while solving Advent
of Code"][fasterthanlime-aoc] series. [Part 1][fasterthanlime-aoc-part1]
includes everything you need to get started, tooling and all, and a delightfully
unusual introduction to file I/O which I won't spoil.

[fasterthanlime]: https://fasterthanli.me
[fasterthanlime-aoc]: https://fasterthanli.me/series/advent-of-code-2022
[fasterthanlime-aoc-part1]: https://fasterthanli.me/series/advent-of-code-2022/part-1

{{< admonition title="Other ways of getting started with Rust"
    type="tip" open=false >}}

When getting started with Rust, I tried a few things out from
<https://www.rust-lang.org/learn>, but my recommendation is this: Before
installing it, before going to the book, before any of that --- go do
[rustlings](https://github.com/rust-lang/rustlings/), specifically use their
Gitpod link. This will set up a free gitpod "cloud IDE" (VSCode-based),
reasonably configured for Rust, and you can get right to live exercises.

{{< /admonition >}}

Having spent some time with Rust, I now see more and more faults with other
programming languages. Others have written many words about this; fasterthanlime
has a couple of [very][golang-wild-ride] [detailed][golang-lies] posts in this
direction; the folks at Discord wrote a great post about [switching from go to
rust to eliminate GC latency][discord-go-rust]. But I'd like to talk about
something far, far simpler.

Let's talk about null checks.

[golang-wild-ride]: https://fasterthanli.me/articles/i-want-off-mr-golangs-wild-ride
[golang-lies]: https://fasterthanli.me/articles/lies-we-tell-ourselves-to-keep-using-golang
[discord-go-rust]: https://discord.com/blog/why-discord-is-switching-from-go-to-rust

## Things that may or may not be there

My initial sense of Rust is that it involves a lot of fighting with the
compiler... and the compiler being right. Getting code to build is much more
difficult than I'm used to, but when it builds --- it works. Not always, but with
a much higher likelihood than I've seen elsewhere. To explain this phenomenon,
let's take a look at cases when data is allowed to be absent.

It is often useful, in code, to deal with something that may or may not be
present. I've recently had the unpleasant experience of dealing with
soccer[^soccer] for work[^world_cup]; I still don't quite get it, so this
example might not make any sense, but bear with me: Let's imagine that a soccer
`Team` has several `players` (each of which is a `Person` with a `name` and
`age`), and may or may not have a `coach`, who is also a `Person`. In JSON, that
would look like this:

[^soccer]: Short for --- did you know? --- Association Football. I live in Ireland,
    which plays multiple kinds of football, so I find "soccer" to be the more
    specific term.

[^world_cup]: I really don't like watching any kind of sportsball, but there was
    a fair bit of excitement around the recent FIFA World Cup, and my
    involvement extended to having to watch some of those matches. Live 🙄. In
    contrast, to relax in the evenings, I did AoC --- so I effectively watch
    soccer for a living and code for fun.

```json
{ 
    "players": [
        {"name": "John Doe", "age": 24},
        {"name": "Richard Roe", "age": 25}
    ],
    // Might be absent:
    "coach": {"name": "Mark Moe", "age": 53}
}
```

Suppose you write some code to handle such a `Team`, and, say, return whether or
not any of the players are older than the coach.

### Go

In Go, you'd probably end up doing something like this:

```go
struct Team {
  Players []Person
  Coach *Person
}

func (t * Team) anyPlayersOlderThanCoach() bool {
  if t.Coach == nil { // YOU WILL FORGET
    return false      // TO DO THIS PART,
  }                   // I ASSURE YOU.

  for _, p in t.Players {
    if p.Age > t.Coach.Age {
      // ...so ^^^^^^^ will sometimes crash.

      return true
    }
  }
  return false
}
```

At some point you will encounter a team without a coach, and your code will
panic and exit with an error. It won't even be a useful error message --- it'll be
something like this (but probably with many more goroutines).

```text
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x480c76]

goroutine 1 [running]:
main.main()
  /tmp/sandbox3217875017/prog.go:17 +0x16

Program exited./Op
```

The issue is that the null (well, `nil`) pointer is used as a way to indicate
"something that is not there", and Go --- just like C --- uses pointers both to
indicate "we're dealing with pointing at memory addresses" and to indicate
"we're dealing with something that may be absent".

Worse yet, because most teams *do* have coaches, this will be a rare case. It'll
likely be shuffled off into the back of the bug queue as a "rare crash", waiting
to jump on you when somehow a coach-free team makes it to the world cup finals.

### Rust

Although rust does support pointers (null and otherwise), those are usually
relegated to [`unsafe`][rust-unsafe] code. In day-to-day rust, indicating that a
value might be absent is done using [`std::Option`][rust-option]. If you were
recreating the same naive approach as Go, you'd end up writing something like
this:

[rust-unsafe]: https://doc.rust-lang.org/std/keyword.unsafe.html
[rust-option]: https://doc.rust-lang.org/std/option/index.html

```rust
struct Team {
    players: Vec<Person>,
    coach: Option<Person>,
}

impl Team {
  fn any_players_older_than_coach(&self) -> bool {
    // Don't code like this, but...

    if self.coach.as_ref().is_none() { // This is the
      return false                     // part you will
    }                                  // forget to do.

    let coach_age = self.coach.as_ref().unwrap().age;
    // ...so this part will crash:      ^^^^^^^^

    self.players.iter().any(|p| p.age > coach_age)
  }
}
```

{{< admonition type="note" >}}

Yes, Rust's support for functional-style programming blows Go's out of the
water. Yes, I'm salty.

{{< /admonition >}}

The error you'd get for forgetting to check whether `coach.as_ref().is_none()`
is actually a bit better:

```text
thread 'main' panicked at 'called `Option::unwrap()` on
a `None` value', src/main.rs:13:45
```

However, there's an extremely handy smoking gun here --- `unwrap` itself. That's
not a function that usually gets used in production[^non-production] code. A
reviewer or linter should be able to catch it. The function should actually be
written like this:

[^non-production]: Rust actually has many useful-while-prototyping functions, like
[`todo!()`](https://doc.rust-lang.org/std/macro.todo.html).

```rust
impl Team {
  fn any_players_older_than_coach(&self) -> bool {
    match &self.coach {
      None => false,
      Some(definitely_a_coach) =>
        self.players.iter().any(|p| p.age > definitely_a_coach.age),
    
      // definitely_a_coach can be called "coach" as well,
      // and usually would - but it's a different variable
      // with a different type.
    }
  }
}
```

Importantly, the type of `definitely_a_coach` is *not* `Option<Person>` --- it's
`Person`. That is, when using `match` (which is fairly standard), the guarantee
that "you made sure the thing is actually there" happens *at compile time*.
Omitting the `None` case is a compilation error.

{{< admonition type="note" >}}

This is a great example of how Rust moves head-scratches from runtime to
compile-time. It's a big part of why it's harder to get Rust code to build.

{{< /admonition >}}

In fact, there's an equivalent way to write this, shorter, but providing the
same safety guarantees:

```rust
impl Team {
  fn any_players_older_than_coach(&self) -> bool {
    if let Some(definitely_a_coach) = &self.coach {
        return self.players.iter().any(|p| p.age > definitely_a_coach.age)
    }
    false // Omitting this is also a compilation error;
          // it won't let you forget the "else" case.
  }
}
```

Importantly, the syntax that *might* panic (`unwrap`) is quite different, easy
to pick out, and does not have to be used at all. In contrast, in other
languages, like Go, we don't get the opportunity to notice that it's happening.
The `coach` pointer gets dereferenced using the same syntax, whether or not it's
guaranteed to not be `nil`.

### Other languages

#### Haskell

This seems to be equivalent to the Haskell `Maybe` type. If I were smart enough
to code in Haskell, I'd be sure. One of the nice things about Rust is that it
allows writing code in imperative style without understanding monads.

#### Java

Java 8 introduced [`java.util.Optional`][java-optional], which does the same
thing as Rust's `Option`. However, the safety guarantees are more limited:

[java-optional]: https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html

* You can check `ifPresent()` and use `get()`, but this is no better than
  checking if a standard reference would be `null` (that is --- nothing makes sure
  that you did so, and if nothing is there --- `get()` throws an exception).
  
  {{< admonition type="note" >}}

  Apparently some external inspectors do check for this, e.g.
  <https://rules.sonarsource.com/java/RSPEC-3655>

  {{< /admonition >}}
* You can use `orElse(defaultValue)`, which makes sense in some cases, but not
  always (what if it's a temperature-in-celsius that might be absent? You can't
  use 0° as a default value).
* You can use various other methods like `filter` and `map`, but that requires
  callback-style programming (which I don't *think* is the norm for Java).

At the end of the day, Java's legacy is probably a limiting factor here --- your
code likely needs to interoperate with a pile of code that simply uses `null`
the traditional way for "thing that is not there".

Finally, researching for this post showed at least one guide claiming the
following as [Misuse of
`Optional`][java-optional-misuse]:

* Passing an `Optional` parameter to a method
* Having an `Optional` field (also discussed [here][java-optional-so]), exactly
  as we're doing here.

[java-optional-misuse]: https://www.baeldung.com/java-optional#misuages
[java-optional-so]: https://stackoverflow.com/questions/23454952/uses-for-optional

...so I guess you're stuck null-checking for those cases.

#### C++

C++17 adds [std::optional][std-optional]. I haven't tried it out, but judging
from [a quick read][cpp-optional-blogpost], it appears to be more robust than
Java's, but still far less safe than Rust's: You're still checking `has_value()`
and risking an exception when calling `value()` (...does your codebase even
[allow for exceptions][google-no-exceptions]?), or using `value_or` if a
sentinel value is acceptable.

[std-optional]: https://en.cppreference.com/w/cpp/utility/optional
[cpp-optional-blogpost]: https://devblogs.microsoft.com/cppblog/stdoptional-how-when-and-why/
[google-no-exceptions]: https://google.github.io/styleguide/cppguide.html#Exceptions

## Why does this matter?

Go is often regarded as a memory-safe[^gokrazy] language. And that's technically
correct in this case --- if you get a null dereference, your code will simply
crash, as opposed to some crazy Undefined Behavior. Presumably your production
setup is resilient to crashes, and you'll catch these crashes in pre-production
anyway.

[^gokrazy]: And people use that reasoning to build some pretty cool stuff, like
    <https://gokrazy.org>.

...except, it'll take you a while to do that. And the crash will seem quite
esoteric, and might not even happen in pre-production (does your test data
contain teams without coaches?)... and, once again, if a coach-free team
suddenly plays a very popular match, are you really set up to deal with such
consistent crashes?

It's possible to build automatic tooling for detecting these cases, and people
far smarter than myself are already doing so. Unfortunately, applying them to
legacy code is an even harder. I've seen such a "you did not check for null"
static analyzer completely miss a case quite similar to the above; and while we
did catch it in pre-production, a lot of people wasted a lot of needless time on
it.

This is also only one (relatively-simple) example of what Rust does about
safety. A more elaborate example is [mutexes][rust-mutex]: A rust mutex "holds"
the protected data, requiring you to `lock()` it to even access the data. This
means that the type-system guarantees that the mutex protects whatever it's
meant to protect. In Go, however, the protected value just [wears the mutex as a
hat][mutex-hat] --- so the compiler has no clue. (There's at least one person
[porting this idea into C++][rustex])

[rust-mutex]: https://doc.rust-lang.org/std/sync/struct.Mutex.html
[mutex-hat]: https://dmitri.shuralyov.com/idiomatic-go#mutex-hat
[rustex]: https://github.com/dragazo/rustex

So examine your programming language; see what safety guarantees you'd like it
to have (try to use the ones it already does!); and perhaps look at Rust for a
bit of inspiration.
