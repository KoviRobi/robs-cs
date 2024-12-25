#import "@preview/touying:0.5.3" as touying: *
#import "unistra/unistra.typ" as unistra: *
#import "unistra/colors.typ": *
#import "unistra/admonition.typ": *

#import "@preview/fletcher:0.5.3" as fletcher: *
#import "codly/codly.typ": *
#import "@preview/bytefield:0.0.6": *
#import "diagraph/lib.typ" as diagraph

#import "utils.typ": *

// '<,'>!ocamlformat - --impl

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#show: codly-init.with()
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS 1],
    subtitle: [_Functional Programming_ 1],
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

  Used in industry

  Eager evaluation.

  Concepts apply to other FP languages

  #pdfpc.speaker-note(```
    - Eager evaluation: Dynamic programming
    - F# is very similar to OCaml
    - ReasonML is/started as an OCaml extension
    - Eager evaluation is one fewer thing to learn on top
  ```)
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
#v(-1em)
```
winget install Microsoft.VisualStudioCode
winget install OCaml.opam
```
Restart terminal
#v(-0.5em)
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
  #v(-1em)
  #codly-reveal((1,3,8), [
    ```ocaml
let greet () = print_endline "Hello, world!"

type 'a list = Nil | Cons of 'a * 'a list

let rec append x y =
  match x with
  | Nil -> y
  | Cons (x, xs) -> Cons (x, append xs y)
    ```
  ])
  #pdfpc.speaker-note(```
    Simple function definition, body is a single expression. Can be multiple
    with semicolons, and using parentheses or begin/end blocks.

    Double semicolon is for the interpreter, to tell it we have stopped typing.

    Defining product types (pairs/tuples) and sum types (tagged unions). Tagged
    as in an enum indicating kind.

    Pattern matching, to deconstruct types.
  ```
  )
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
#unistra.slide[
  Here `i` is unboxed, stored on the stack
  #v(-0.5em)
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
  let i = 123 in
  print_int i

let main () = test ()
        ```
      ][
        #sublist([
          + ```ocaml main```
          + ```ocaml test```, returns to line 5
            + ```ocaml i = 123```
          + ```ocaml print_int```, returns to line 3
            + ```ocaml i = 123```
        ], stack)
      ]
    ]
  }
  #v(-0.5em)
  But most values are boxed, so heap allocated
]

#unistra.slide[
  Here `f` is boxed, stored on the heap
  #v(-0.5em)
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
  let f = 1.23 in
  print_float f

let main () = test ()
        ```
      ][
        #sublist([
          + main
          + ```ocaml test```, returns to line 5
            + ```ocaml f = ```$angle.l"pointer to heap"angle.r$
          + ```ocaml print_float```, returns to line 3
            + ```ocaml x = ```$angle.l"pointer to heap"angle.r$
        ], stack)
      ]
    ]
  }
  #v(-0.5em)
  But most values are boxed, so heap allocated
]

== Lists
#unistra.slide[
  #v(-1em)
  #only(1)[
    ```ocaml
type 'a list = Nil | Cons of 'a * 'a list
    ```
  ]
  #only(2)[
    ```ocaml
type 'a list = Nil | Cons of 'a * 'a list

let l = Cons ("hello", Cons ("world", Nil))
    ```
    #diagraph.raw-render(
    ```dot
    digraph {
      rankdir=LR;
      node [shape=rectangle];
      l -> C0;
      C0 [shape=none,label=<
        <table border="0" cellborder="1" cellspacing="0">
          <tr><td>Cons</td><td port="hd">pointer</td><td port="tl">pointer</td></tr>
        </table>>]
      C0:s -> "hello":n;
      C0:e -> C1;
      C1 [shape=none,label=<
        <table border="0" cellborder="1" cellspacing="0">
          <tr><td>Cons</td><td port="hd">pointer</td><td port="tl">pointer</td></tr>
        </table>>]
      C1:s -> "world":n;
      C1:e -> Nil;
    }
    ```)
  ]
  #only(3)[
    ```ocaml
type 'a list = Nil | Cons of 'a * 'a list

let l = Cons (1, Cons (2, Nil))
    ```
    #diagraph.raw-render(
    ```dot
    digraph {
      rankdir=LR;
      node [shape=rectangle];
      l -> C0;
      C0 [shape=none,label=<
        <table border="0" cellborder="1" cellspacing="0">
          <tr><td>Cons</td><td port="hd">1</td><td port="tl">pointer</td></tr>
        </table>>]
      C0:e -> C1;
      C1 [shape=none,label=<
        <table border="0" cellborder="1" cellspacing="0">
          <tr><td>Cons</td><td port="hd">2</td><td port="tl">pointer</td></tr>
        </table>>]
      C1:e -> Nil;
    }
    ```)
  ]
  #codly-reveal((1,6,8), start: 4, [
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let rec append xs ys =
  match xs with
  | [] -> ys
  | x :: xs' -> x :: append xs' ys

let ( @ ) = append
    ```
  ])
]

== Tail recursion
#unistra.slide[
  #v(-1em)
  ```ocaml
let rec fold_left f acc lst = match lst with
  | [] -> acc
  | l :: ls -> fold_left f (f acc l) ls

let rec fold_right f lst acc = match lst with
  | [] -> acc
  | l :: ls -> f l (fold_right f ls acc)
  ```
  #pdfpc.speaker-note(```
    Fundamental list operation.
  ```)
]

#unistra.slide[
  #v(-1em)
  ```ocaml
fold_left  ( + ) 0 [ 1; 2; 3 ]
  = 6;;

fold_right ( + ) [ 1; 2; 3 ] 0
  = 6;;
  ```
]

#unistra.slide[
  #codly(display-name: false, display-icon: false)
  #v(-1em)
  ```ocaml
fold_left  (fun a b -> b :: a) [] [ 1; 2; 3; 4; 5 ]
  = [5;4;3;2;1];;

fold_right (fun a b -> a :: b) [ 1; 2; 3; 4; 5 ] []
  = [1;2;3;4;5];;
  ```
]

#unistra.slide[
  #codly(display-name: false, display-icon: false)
  #v(-1em)
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
  #codly(display-name: false, display-icon: false)
  #v(-1em)
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
  #codly(display-name: true, display-icon: true)
]

== Why tail recursion
#unistra.slide[
  Compare imperative languages
  #v(-0.5em)
  ```cpp
  for (auto & element : list) { /* ... */ }
  ```
  #v(-0.5em)
  #pause
  ```python
  for element in list:
    # ...
  ```
  #v(-0.5em)
  #pause
  Element reference changes between iterations.

  #pdfpc.speaker-note(```
    Fold is a effectively the loop over the list, hence why it is so
    fundamental.
  ```)
]

== Merge-sort
#unistra.slide[
  #fletcher-diagram(
    spacing: (0em, .5em),
    node-stroke: 1pt + black,
    node-corner-radius: 0em,
    node-shape: rect,

    for x in range(15) {
      node((x,  3), stroke: white, " ")
    },

    node((0,  0), "7"),
    node((1,  0), "1"),
    node((2,  0), "2"),
    node((3,  0), "8"),
    node((4,  0), "6"),
    node((5,  0), "5"),
    node((6,  0), "4"),
    node((7,  0), "3"),
    node((15, 0), stroke: none, " "),

    (pause,),

    node((0,  1), "7"),
    node((1,  1), "1"),
    node((2,  1), "2"),
    node((3,  1), "8"),
    node((8,  1), "6"),
    node((9,  1), "5"),
    node((10, 1), "4"),
    node((11, 1), "3"),
    node((15, 1), stroke: none, " "),

    (pause,),

    node((0,  2), "7"),
    node((1,  2), "1"),
    node((4,  2), "2"),
    node((5,  2), "8"),
    node((8,  2), "6"),
    node((9,  2), "5"),
    node((12,  2), "4"),
    node((13, 2), "3"),

    (pause,),

    node((0,  3), "7"),
    node((2,  3), "1"),
    node((4,  3), "2"),
    node((6,  3), "8"),
    node((8,  3), "6"),
    node((10, 3), "5"),
    node((12, 3), "4"),
    node((14, 3), "3"),
    node((15, 3), stroke: none, " "),

    (pause,),

    node((0,  4), "1"),
    node((1,  4), "7"),
    node((4,  4), "2"),
    node((5,  4), "8"),
    node((8,  4), "5"),
    node((9,  4), "6"),
    node((12,  4), "3"),
    node((13, 4), "4"),
    node((15, 4), stroke: none, " "),

    (pause,),

    node((0,  5), "1"),
    node((1,  5), "2"),
    node((2,  5), "7"),
    node((3,  5), "8"),
    node((8,  5), "3"),
    node((9,  5), "4"),
    node((10,  5), "5"),
    node((11,  5), "6"),

    (pause,),

    node((0,  6), "1"),
    node((1,  6), "2"),
    node((2,  6), "3"),
    node((3,  6), "4"),
    node((4,  6), "5"),
    node((5,  6), "6"),
    node((6,  6), "7"),
    node((7,  6), "8"),
    node((15, 6), stroke: none," "),

    render: (grid, nodes, edges, options) => {
      cetz.canvas({
        draw-diagram(grid, nodes, edges, debug: options.debug)
        let n0 = find-node-at(nodes, (15, 0))
        let n1 = find-node-at(nodes, (15, 1))
        let n2 = find-node-at(nodes, (15, 3))
        let n3 = find-node-at(nodes, (15, 4))
        let n4 = find-node-at(nodes, (15, 6))
        if repr(n1.post) != "hide" {
          cetz.decorations.brace(n0.pos.xyz, n2.pos.xyz, name: "split")
          cetz.draw.content("split.content", anchor: "west", [Split])
        }

        if repr(n3.post) != "hide" {
          cetz.decorations.brace(n2.pos.xyz, n4.pos.xyz, name: "merge")
          cetz.draw.content("merge.content", anchor: "west", [Merge])
        }
      })
    }
  )
]

== Coding challenge
#unistra.slide[
  #v(-1em)
  Implement merge-sort
  #v(-0.5em)
  ```ocaml
let rec merge xs ys = ...
let rec sort lst = ...
  ```
  #v(-0.5em)
  #pause
  / Hint 1: Merging sorted lists -- only need to consider first element
  #pause
  / Hint 2: Implement list splitting
  #pause
  / Hint 3: Loops forever? Trace it to debug
  #v(-0.5em)
  ```ocaml
let isort : int list -> int list = sort;;
#trace isort;;
  ```
]

#unistra.slide[
  #v(-1em)
  ```ocaml
let rec merge xs ys = match xs, ys with
  | x::xs', y::ys' when x<y -> x::merge xs' ys
  | x::xs', y::ys'          -> y::merge xs ys'
  | lst, [] | [], lst -> lst
  ```
]

#unistra.slide[
  #v(-1em)
  ```ocaml
let rec split n = function x::xs when n>0 ->
    let (a, b) = split (n-1) xs in (x::a, b)
  | xs  -> ([], xs)

let rec sort = function
  | ([] | [_]) as sorted -> sorted
  | lst -> let a, b = split (List.length lst / 2) lst in
    merge (sort a) (sort b)
  ```
]


== Complexity
#unistra.slide[
    - Replace known functions with cost
  #only(1)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xs ys = match xs, ys with
  | x::xs', y::ys' when x<y -> x::merge xs' ys
  | x::xs', y::ys'          -> y::merge xs ys'
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(2)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = match xl, yl with
  | xl>0 && yl>0            -> 1 + merge (xl-1) yl
  | xl>0 && yl>0            -> 1 + merge xl (yl-1)
  | xl=0 || yl=0      -> 1
    ```
  ]
  #only(3)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = xl + yl
    ```
  ]
  #only(4)[
    - Space:
    #v(-0.5em)
    ```ocaml
let rec merge xs ys = match xs, ys with
  | x::xs', y::ys' when x<y -> x::merge xs' ys
  | x::xs', y::ys'          -> y::merge xs ys'
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(5)[
    - Space:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = match xl, yl with
  | xl>0 && yl>0            -> 1 + merge (xl-1) yl
  | xl>0 && yl>0            -> 1 + merge xl (yl-1)
  | xl=0 || yl=0      -> 1
    ```
  ]
  #only(6)[
    - Space (note, extra space):
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = xl + yl
    ```
  ]
]

== Type checking 1
- Introduce Church-encoded lists?
- Use to introduce module interface files?
- Use types to tame them?
- From a type-annotation point
```ocaml
type ('el, 'acc) flist =
  ('el -> 'acc -> 'acc) -> 'acc -> 'acc

let empty : ('el, 'acc) flist = fun f x -> x

let cons (l : 'el) (ls : ('el, 'acc) flist) :
    ('el, 'acc) flist =
 fun f x -> f l (ls f x)

let to_list (ls: ('el, 'acc) flist) : 'el list =
  ls (fun a b -> a::b) []

let append
    (xs:('el, 'acc) flist)
    (ys: ('el, 'acc) flist) :
  ('el, 'acc) flist =
  fun f x -> xs f (ys f x)
```

== Combinatorial functions
- Graph colouring?
- Monadic syntax/custom let?

== Type checking 2
- Show how it helps with coding up the combinatorial function
- From an inference point

== Trees
== Red-black tree
- From SV2 material
- Coding exercise
== Modules/Functors?
- Making a dictionary/set, custom comparator

== Monadic syntax
== Infix operators, custom let
== Option; monads
== Exceptions

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
