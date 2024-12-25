#import "@preview/touying:0.5.3" as touying: *
#import "../unistra/unistra.typ" as unistra: *
#import "../unistra/admonition.typ": *

#import "@preview/fletcher:0.5.3" as fletcher: *
#import "../codly/codly.typ": *
#import "@preview/codly-languages:0.1.3": *
#import "@preview/bytefield:0.0.6": *
#import "../diagraph/lib.typ" as diagraph

#import "../utils.typ": *

// '<,'>!ocamlformat - --impl

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#show: codly-init.with()
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS 2],
    subtitle: [Linked Lists],
    author: [Robert Kovacsics],
    date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
    logo: image(width: 80%, "../branding/carallon/carallon_logo_white.png"),
  ),
  config-common(
    // show-notes-on-second-screen: right,
    preamble: {
      codly(
        languages: codly-languages,
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

#title-slide(logo: image(height: 95%, "../branding/carallon/carallon_logo_white.png"))

= Linked Lists
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
