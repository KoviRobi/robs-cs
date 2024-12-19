#import "@preview/touying:0.5.3": *
#import "unistra/unistra.typ": *
#import "unistra/colors.typ": *
#import "unistra/admonition.typ": *

#import "@preview/codly:1.0.0": *
#import "@preview/bytefield:0.0.6": *

#let codly-reveal(pauses, content, start: 1) = {
  for (slide, end) in pauses.enumerate(start: start) {
    only(slide)[
      #codly-range(end: end)
      #content
    ]
  }
}

#show: codly-init.with()
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS],
    subtitle: [_Functional Programming_],
    author: [Robert Kovacsics],
    date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
    logo: image(width: 80%, "branding/carallon/carallon_logo_white.png"),
  ),
  config-common(show-notes-on-second-screen: right,
    preamble: {
      codly(
        languages: (
          ml: (
            name: "OCaml",
            icon: text(font: "CaskaydiaCove NF")[\u{e67a}#h(0.4em)],
          ),
        ),
        zebra-fill: luma(251),
        lang-fill: (lang) => lang.color.lighten(95%),
      )
    }
  ),
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide(logo: image(height: 95%, "branding/carallon/carallon_logo_white.png"))

= OCaml overview
== Why OCaml?
#slide[

  Because I know it. :p

  Simple syntax.

  Eager evaluation.

  Paradigm over syntax.

  #speaker-note[
    / Eager evaluation: Dynamic programming
    / Paradigm: Is the difficult bit, different syntax e.g. F#sym.sharp easy to
      learn on top. Haskell is a bit more difficult on top, as it is lazy, but
      it is a pretty language.
  ]
]

== Ergonomics
#slide[
  OCaml interpreter is minimal:
  / #sym.arrow.r.double: Use `utop`, or an editor + lang server

  Or I have a docker image with Jupyter OCaml
  #pause

  Helpful interpreter commands:
  / `#help;;`: if you forget
  / `#use "file.ml";;`: to load a file
  / `#show thing;;`: to show type, or module contents
]

#hero(image("./images/vs-code/1-ocaml-sandbox-select.png"))
#hero(image("./images/vs-code/2-ocaml-sandbox-selected.png"))
#hero(image("./images/vs-code/3-workspace-settings.png"))
#hero(image("./images/vs-code/4-eval-selection.png"))
#hero(image("./images/vs-code/5-doc-hover.png"))
#hero(image("./images/vs-code/6-tab-completion.png"))

== Syntax overview
#slide[
  #codly-reveal((1,3,7), [
    ```ocaml
let greet () = print_endline "Hello, world!";;

type 'a list = Nil | Cons of 'a * 'a list;;

let rec append x y = match x with
  | Nil -> y
  | Cons(x, xs) -> Cons(x, append xs b)
    ```
  ])
  #speaker-note[
    Simple function definition, body is a single expression. Can be multiple
    with semicolons, and using parentheses or begin/end blocks.

    Double semicolon is for the interpreter, to tell it we have stopped typing.

    Defining product types (pairs/tuples) and sum types (tagged unions). Tagged
    as in an enum indicating kind.

    Pattern matching, to deconstruct types.
  ]
]

= Quick core concepts
== Data
+ Types disappear at runtime
  + No polymorphic print
+ Boxed values (as in other GC'd languages)
  + 31-bit integers unboxed
  + Booleans, types without values (e.g. `Nil`) represented as integers.
+ Floating-point always boxed doubles

== Boxing
// TODO: Drop
Here `x` is stored on the stack
```ocaml
let test () =
  let x = 123
  in print_int x;;
```
But most values are heap allocated

== Lists
#slide[
    ```ocaml
type 'a list = Nil | Cons of 'a * 'a list;;
    ```
    ```ocaml
type 'a list = [] | (::) of 'a * 'a list;;
    ```
]

// TODO: Linked list diagram

== Tail recursion

== Complexity
=== Fibonacci


= OCaml

== Type checking
== Tail calls

```dot
FoCS -> Prolog
FoCS -> Types
FoCS -> CompTheory (lambda calculus)
FoCS -> RegEx
RegEx -> Memoization (for backtracking implementations)
RegEx -> CompTheory (finite-state automata)
RegEx -> Complexity (C++ exptime backtracking regex, vs automata implementation)
```

= Regex
+ Introduce
+ Mention parsing HTML meme
+ Parsing balanced pairs
  + Example: C++ templates, ellipsisation
    Real worked example

#slide[
  ```
auto Cli<PrintfIo&>::Parser<Cli<PrintfIo&>::Command<1ul>, Cli<PrintfIo&>::Command<1ul, NumArg<unsigned int, 0u, 23u> >, Cli<PrintfIo&>::Command<1ul, ChoiceArg<Status, 2ul> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<FanGroup, 10ul> >, Cli<PrintfIo&>::Command<2ul, NumArg<unsigned char, (unsigned char)0, (unsigned char)100> >, Cli<PrintfIo&>::Command<2ul, ChoiceArg<FanGroup, 10ul>, NumArg<unsigned char, (unsigned char)0, (unsigned char)100> >, Cli<PrintfIo&>::PageBreak, Cli<PrintfIo&>::Command<1ul, ChoiceArg<FanSensors, 29ul> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::Id, 2ul>, NumArg<unsigned short, (unsigned short)0, (unsigned short)65535> >, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::Id, 2ul>, NumArg<unsigned short, (unsigned short)0, (unsigned short)65535>, NumArg<unsigned char, (unsigned char)0, (unsigned char)255> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::VersionY, 6ul> >, Cli<PrintfIo&>::PageBreak, Cli<PrintfIo&>::Command<2ul, ChoiceArg<IoCards::Card, 4ul>, NumArg<bool, false, true> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<3ul>, Cli<PrintfIo&>::Command<3ul>, Cli<PrintfIo&>::Command<3ul, StrArg>, Cli<PrintfIo&>::Command<3ul> >::help(PrintfIo&, std::basic_string_view<char, std::char_traits<char> >, bool) const::{lambda<unsigned long... $N0>(std::integer_sequence<unsigned long, ($N0)...>)#1}::operator()<0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul, 13ul, 14ul, 15ul, 16ul, 17ul, 18ul, 19ul, 20ul>(std::integer_sequence<unsigned long, 0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul, 13ul, 14ul, 15ul, 16ul, 17ul, 18ul, 19ul, 20ul>) const
  ```
  Ouch!
]
#slide[
  End result
  ```
auto Cli⟨...⟩::Parser⟦...⟧::help(PrintfIo&, std::basic_string_view⟪...⟫, bool) const::{lambda⟨...⟩(std::integer_sequence⟨...⟩)#1}::operator()⟨...⟩(std::integer_sequence⟨...⟩) const
  ```
  "Readable for C++" -- most people would say ugly, but then you run out of
  terms to describe the original one.
]
#slide[
  ```sh
sed -e 's/\(([^()]*)\)<\(([^()]*)\)/\1⍃\2/g' \
  ```
  Replace comparison less-than, because C++ abuses less-than and greater-than
  symbols as angle brackets.
#pause
  #codly(offset: 1)
  ```sh
    -e 's/\(([^()]*)\)>\(([^()]*)\)/\1⍄\2/g' \
  ```
  Same but for greater-than.
]
#slide[
  Now we can ellipsisise the innermost balanced pair.
  #codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟨...⟩/g' \
  ```
#pause
  Which leaves us with the next balanced pair.
#codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟪...⟫/g' \
  ```
]
#slide[
  And again.
  #codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟦...⟧/g' \
  ```
#pause
  The Ginosaji never gives up.
  #codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟬...⟭/g' |
  ```
]
#slide[
    Repeated removal of innermost parentheses, as regex cannot do balanced
    pairs. Replace with non-parentheses.
    Results in:
    ```
auto Cli⟨...⟩::Parser⟦...⟧::help(PrintfIo&, std::basic_string_view⟪...⟫, bool) const::{lambda⟨...⟩(std::integer_sequence⟨...⟩)#1}::operator()⟨...⟩(std::integer_sequence⟨...⟩) const
    ```
]

    Also most regexes irregular in every sense of the word. Demo the
    exponential PCRE blowup.

= Operating systems?
SystemTap? Look at RNW's DTrace things again

= Concurrency models
C++11 memory models
