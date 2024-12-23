#import "@preview/touying:0.5.3": *
#import "unistra/unistra.typ" as unistra: *
#import "unistra/colors.typ": *
#import "unistra/admonition.typ": *

#import "codly/codly.typ": *
#import "@preview/bytefield:0.0.6": *
#import "diagraph/lib.typ" as diagraph

#import "utils.typ": *

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
  config-common(
    // show-notes-on-second-screen: right,
    preamble: {
      codly(
        languages: (
          ocaml: (
            name: "OCaml",
            icon: box(image(width: 1em, height: 0.8em, fit: "contain", "images/logos/ocaml-logo.svg"))+h(0.1em),
            color: rgb("#f29100"),
          ),
          cpp: (
            name: "C++",
            icon: box(image(width: 1em, height: 0.8em, fit: "contain", "images/logos/cpp_logo.svg")),
            color: rgb("#659ad2"),
          ),
          python: (
            name: "python",
            icon: box(baseline: 0.1em, image(width: 1em, height: 0.8em, fit: "contain", "images/logos/python-logo-only.svg")),
            color: rgb("#ffd43b"),
          ),
        ),
        zebra-fill: luma(251),
        lang-fill: (lang) => lang.color.lighten(95%),
        highlight-inset: 0pt,
        highlight-outset: 0.32em,
        highlight-clip: false,
        highlight-stroke: color => 0pt,
      )
    }
  ),
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide(logo: image(height: 95%, "branding/carallon/carallon_logo_white.png"))

#unistra.slide[
#sym.space.quad When old age shall this generation waste,                                \
#sym.space.quad #sym.space.quad Thou shalt remain, in midst of other woe                 \
Than ours, a friend to man, to whom thou say'st,                                         \
#sym.space.quad "Beauty is truth, truth beauty,"---that is all                           \
#sym.space.quad #sym.space.quad Ye know on earth, and all ye need to know.               \
                                                                                         \
#sym.space.quad #sym.space.quad #sym.space.quad #sym.space.quad --- Ode to a Grecian Urn \
#sym.space.quad #sym.space.quad #sym.space.quad #sym.space.quad #sym.space.quad By John Keats
]

= OCaml overview
== Why OCaml?
#unistra.slide[

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
#unistra.slide[
  OCaml interpreter is minimal:
  / #sym.arrow.r.double: Use `utop`, or an editor + lang server

  Or I have a docker image with Jupyter OCaml
  #pause

  Helpful interpreter commands:
  / `#help;;`: if you forget
  / `#use "file.ml";;`: to load a file
  / `#show thing;;`: to show type, or module contents
]

== MS Windows Setup
```
winget install Microsoft.VisualStudioCode
winget install OCaml.opam
```
Restart terminal
```
opam init
opam --install ocaml-lsp-server odoc ocamlformat utop
code --install-extension ocamllabs.ocaml-platform
```

#hero(image("./images/vs-code/1-ocaml-sandbox-select.png"))
#hero(image("./images/vs-code/2-ocaml-sandbox-selected.png"))
#hero(image("./images/vs-code/3-workspace-settings.png"))
#hero(image("./images/vs-code/4-eval-selection.png"))
#hero(image("./images/vs-code/5-doc-hover.png"))
#hero(image("./images/vs-code/6-tab-completion.png"))

== Syntax overview
#unistra.slide[
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
Here `x` is unboxed, stored on the stack
#for (slide, (line, stack)) in (
  (4, 1), (0, 2), (1, 3), (2, 3), (-1, 5), (2, 3), (4, 1)
).enumerate(start: 1){
only(slide)[
  #components.side-by-side[
    #codly(highlights:(
      (line: line),
    ))
    ```ocaml
let test () =
  let x = 123
  in print_int x
let main() =
  test()
    ```
  ][
    #sublist([
      + main
      + test, returns to line 5
        + ```ocaml x = 123```
      + print_int, returns to line 3
        + ```ocaml x = 123```
    ], stack)
  ]
  But most values are boxed, so heap allocated
]
}

== Lists
#unistra.slide[
  #only(1)[
    ```ocaml
type 'a list = Nil | Cons of 'a * 'a list;;
    ```
  ]
  #only(2)[
    ```ocaml
type 'a list = Nil | Cons of 'a * 'a list;;
let l = Cons(a, Cons(b, Nil))
    ```
    #diagraph.raw-render(
    ```dot
    digraph {
      rankdir=LR;
      node [shape=rectangle];
      l -> C0;
      C0 [shape=none,label=<
        <table border="0" cellborder="1" cellspacing="0">
          <tr><td>Cons</td><td port="hd">'a</td><td port="tl">'a list</td></tr>
        </table>>]
      C0:s -> a:n;
      C0:e -> C1;
      C1 [shape=none,label=<
        <table border="0" cellborder="1" cellspacing="0">
          <tr><td>Cons</td><td port="hd">'a</td><td port="tl">'a list</td></tr>
        </table>>]
      C1:s -> b:n;
      C1:e -> Nil;
    }
    ```)
  ]
  #codly-reveal((1,5), start: 3, [
    ```ocaml
type 'a list = [] | (::) of 'a * 'a list;;

let rec append xs ys = match xs with
  | [] -> ys
  | x::xs' -> x::append xs' ys
    ```
  ])
  #only(5)[
    ```ocaml
type 'a list = [] | (::) of 'a * 'a list;;

let rec (@) xs ys = match xs with
  | [] -> ys
  | x::xs' -> x::(xs' @ ys)
    ```
  ]
]

== Tail recursion
#unistra.slide[
  ```ocaml
let rec fold_left f acc lst = match lst with
  | [] -> acc
  | l::ls -> fold_left f (f acc l) ls

let rec fold_right f lst acc = match lst with
  | [] -> acc
  | l::ls -> f l (fold_right f ls acc)
  ```
]

#unistra.slide[
  ```ocaml
fold_left  (+) 0 [1;2;3]
  = 6;;

fold_right (+) [1;2;3] 0
  = 6;;
  ```
]

#unistra.slide[
  ```ocaml
fold_left  (fun a b -> b::a) [] [1;2;3;4;5]
  = [5;4;3;2;1];;

fold_right (fun a b -> a::b) [1;2;3;4;5] []
  = [1;2;3;4;5];;
  ```
]

#codly(
  display-name: false,
  display-icon: false,
)
#unistra.slide[
  #let foldr = [
    ```ocaml
let rec foldr f lst acc =
  match lst with
  | [] -> acc
  | l::ls ->
    f l (foldr f  ls acc)
    ```
  ]
  #let entries = (
    ((line: 1, start: 3, end: 16), 1),
    ((line: 3, start: 3, end: 12), 1),
    ((line: 4, start: 5, end: 25), 2),

    ((line: 1, start: 3, end: 16), 3),
    ((line: 3, start: 3, end: 12), 3),
    ((line: 4, start: 5, end: 25), 4),

    ((line: 1, start: 3, end: 16), 5),
    ((line: 3, start: 3, end: 12), 5),
    ((line: 4, start: 5, end: 25), 6),

    ((line: 1, start: 3, end: 16), 7),
    ((line: 2, start: 3, end: 13), 7),
  )
  #components.side-by-side[
    #for (slide, (hi, stack)) in entries.enumerate(start: 1) {
      only((slide,))[
        #codly(
          highlights: (hi,),
        )
        #foldr
      ]
    }
    #only(range(entries.len() + 1, entries.len() + 4))[
      #codly(
        highlights: ((line: 4, start: 5, end: 25),),
      )
      #foldr
    ]
  ][
    #for (slide, (hi, stack)) in entries.enumerate(start: 1) {
      only(slide,)[
        #sublist([
          + ```ocaml foldr (+) [1;2;3] 0```
            + line 5 ```ocaml (+) 1 _```
          + ```ocaml foldr (+) [2;3]   0```
            + line 5 ```ocaml (+) 2 _```
          + ```ocaml foldr (+) [3]     0```
            + line 5 ```ocaml (+) 3 _```
          + ```ocaml foldr (+) []      0```
        ], stack)
      ]
    }
    #only(entries.len() + 1,)[
      + ```ocaml foldr (+) [1;2;3] 0```
        + line 5 ```ocaml (+) 1 _```
      + ```ocaml foldr (+) [2;3]   0```
        + line 5 ```ocaml (+) 2 _```
      + ```ocaml foldr (+) [3]     0```
        + line 5 ```ocaml (+) 3 0```
    ]
    #only(entries.len() + 2,)[
      + ```ocaml foldr (+) [1;2;3] 0```
        + line 5 ```ocaml (+) 1 _```
      + ```ocaml foldr (+) [2;3]   0```
        + line 5 ```ocaml (+) 2 3```
    ]
    #only(entries.len() + 3,)[
      + ```ocaml foldr (+) [1;2;3] 0```
        + line 5 ```ocaml (+) 1 5```
    ]
  ]
]

#unistra.slide[
  #components.side-by-side[
    #for (slide, hi) in (
      (line: 1, start: 3, end: 16),
      (line: 3, start: 3, end: 12),
      (line: 4, start: 5, end: 25),

      (line: 1, start: 3, end: 16),
      (line: 3, start: 3, end: 12),
      (line: 4, start: 5, end: 25),

      (line: 1, start: 3, end: 16),
      (line: 3, start: 3, end: 12),
      (line: 4, start: 5, end: 25),

      (line: 1, start: 3, end: 16),
      (line: 2, start: 3, end: 13),
    ).enumerate(start: 1) {
    only(slide)[
      #codly(
        highlights: (hi,),
      )
        ```ocaml
let rec foldl f acc lst =
  match lst with
  | [] -> acc
  | l::ls ->
    foldl f (f acc l) ls
        ```
      ]
    }
  ][
    #only((1,2,3))[
      + ```ocaml foldl (+) 0 [1;2;3]```
    ]
    #only((4,5,6))[
      + ```ocaml foldl (+) 1 [2;3]```
    ]
    #only((7,8,9))[
      + ```ocaml foldl (+) 3 [3]```
    ]
    #only((10,11))[
      + ```ocaml foldl (+) 6 []```
    ]
  ]
]
#codly(
  display-name: true,
  display-icon: true,
)

== Why tail calls -- no while loops
== Sorting
== Complexity
== Type checking 1
== Combinatorial functions
== Type checking 2
== Monadic syntax
== Infix operators, custom let
== Modules, functors
== Exceptions
== Option; monads

= Outline
#diagraph.raw-render(width: 80%,
```dot
digraph {
  FoCS -> Prolog
  FoCS -> Types
  FoCS -> CompTheory [label="(lambda calculus)"]
  FoCS -> RegEx
  RegEx -> CompTheory [label="(finite-state\nautomata)"]
  RegEx -> Complexity [label="(naive backtracking\nvs automata)"]
  RegEx -> Memoization [label="(for backtracking\nimplementations)"]
}
```
)

= Regex
+ Introduce
+ Mention parsing HTML meme
+ Parsing balanced pairs
  + Example: C++ templates, ellipsisation
    Real worked example

#unistra.slide[
  ```
auto Cli<PrintfIo&>::Parser<Cli<PrintfIo&>::Command<1ul>, Cli<PrintfIo&>::Command<1ul, NumArg<unsigned int, 0u, 23u> >, Cli<PrintfIo&>::Command<1ul, ChoiceArg<Status, 2ul> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<FanGroup, 10ul> >, Cli<PrintfIo&>::Command<2ul, NumArg<unsigned char, (unsigned char)0, (unsigned char)100> >, Cli<PrintfIo&>::Command<2ul, ChoiceArg<FanGroup, 10ul>, NumArg<unsigned char, (unsigned char)0, (unsigned char)100> >, Cli<PrintfIo&>::PageBreak, Cli<PrintfIo&>::Command<1ul, ChoiceArg<FanSensors, 29ul> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::Id, 2ul>, NumArg<unsigned short, (unsigned short)0, (unsigned short)65535> >, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::Id, 2ul>, NumArg<unsigned short, (unsigned short)0, (unsigned short)65535>, NumArg<unsigned char, (unsigned char)0, (unsigned char)255> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::VersionY, 6ul> >, Cli<PrintfIo&>::PageBreak, Cli<PrintfIo&>::Command<2ul, ChoiceArg<IoCards::Card, 4ul>, NumArg<bool, false, true> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<3ul>, Cli<PrintfIo&>::Command<3ul>, Cli<PrintfIo&>::Command<3ul, StrArg>, Cli<PrintfIo&>::Command<3ul> >::help(PrintfIo&, std::basic_string_view<char, std::char_traits<char> >, bool) const::{lambda<unsigned long... $N0>(std::integer_sequence<unsigned long, ($N0)...>)#1}::operator()<0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul, 13ul, 14ul, 15ul, 16ul, 17ul, 18ul, 19ul, 20ul>(std::integer_sequence<unsigned long, 0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul, 13ul, 14ul, 15ul, 16ul, 17ul, 18ul, 19ul, 20ul>) const
  ```
  Ouch!
]
#unistra.slide[
  End result
  ```
auto Cli⟨...⟩::Parser⟦...⟧::help(PrintfIo&, std::basic_string_view⟪...⟫, bool) const::{lambda⟨...⟩(std::integer_sequence⟨...⟩)#1}::operator()⟨...⟩(std::integer_sequence⟨...⟩) const
  ```
  "Readable for C++" -- most people would say ugly, but then you run out of
  terms to describe the original one.
]
#unistra.slide[
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
#unistra.slide[
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
#unistra.slide[
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
#unistra.slide[
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

MirageOS?

= Concurrency models
C++11 memory models
