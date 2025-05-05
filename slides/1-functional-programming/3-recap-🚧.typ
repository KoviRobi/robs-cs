#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 3],
  subtitle: [Recap],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

= Expression oriented
- Everything has a value
  ```ocaml
let foo x = if x then 1 else 2
  ```
  No need for `return 1` or `return 2`
- Types of both `then` and `else` clauses have to be the same

= Syntax overview
#slide[
  #v(-1em)
  #codly(display-name: true, display-icon: true)
    ```ocaml
let greet () = print_endline "Hello, world!"

type fruit = Apple | Orange

match thing with Apple -> "red" | Orange -> "orange"

if predicate then true_case else false_case
  ```
  #note[
    Simple function definition, body is a single expression. Can be multiple
    with semicolons, and using parentheses or begin/end blocks.

    Double semicolon is for the interpreter, to tell it we have stopped typing.

    Defining product types (pairs/tuples) and sum types (tagged unions). Tagged
    as in an enum indicating kind.

    Pattern matching, to deconstruct types.
  ]
]

#slide[
  #codly(display-name: false, display-icon: false)
  #v(-1em)
  ```ocaml
fun (x, y) -> x + y

function Apple -> "red" | Orange -> "orange"

match arg with
  | (num, min, _) when num < min -> min
  | (num, _, max) when num > max -> max
  | (num, _, _) -> num
  ```
]

= Tail calls

```ocaml
let rec sum(n) =
  if n = 0 then 0 else n + sum(n-1)

let sum'(n) =
  let rec loop (n, acc) =
  if n = 0 then acc else loop(n-1, n + acc)
  in loop(n, 0)
```

= Linked Lists
#slide[
  #v(-1em)
  #only(1)[
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let l = 1 :: 2 :: 3 :: []
    ```
  ]
  #codly-reveal((0,8))[
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let l = [1; 2; 3]

let rec append (xs, ys) =
  match xs with
  | [] -> ys
  | x :: xs' -> x :: append (xs', ys)
    ```
  ]
  #only(1)[
    #diagram(
      node((0, 0), box(inset: 0.5em, stroke: black + 1pt, ```ocaml l```)),

      edge("->"),

      node((1, 0), grid(columns: 3, inset: 0.5em, stroke: black + 1pt)[
        ```ocaml ::```][```ocaml 1```][#sym.space.en]),

      edge((rel: (4em, 0mm), to: (1,0)), (rel: (-5em, 0mm), to: (1, 1)), snap-to: (none, auto), "->"),

      node((1, 1), grid(columns: 3, inset: 0.5em, stroke: black + 1pt)[
        ```ocaml ::```][```ocaml 2```][#sym.space.en]),

      edge((rel: (4em, 0mm), to: (1,1)), auto, snap-to: (none, auto), "->"),

      node((2, 0), grid(columns: 3, inset: 0.5em, stroke: black + 1pt)[
        ```ocaml ::```][```ocaml 3```][#sym.space.en]),

      edge((rel: (4em, 0mm), to: (2, 0)), auto, snap-to: (none, auto), "->"),

      node((3, 0), box(inset: 0.5em, stroke: black + 1pt, ```ocaml []```))
    )
  ]
]

= Merge-sort
#slide[
  #components.side-by-side(columns: (2fr, 3fr))[
    #v(-1em)
    Split
    #v(-0.5em)
    #for (slide, args) in (
      (1, (range: (0, 1), highlights: ((line: 1),))),
      (2, (range: (0, 1), highlights: ((line: 1),))),
      (3, (range: (0, 2), highlights: (
            (line: 2, end: 7, fill: green.A),
            (line: 2, start: 9, fill: yellow.A),))),
      (4, (range: (0, 2), highlights: (
            (line: 2, end: 7, fill: green.A),
            (line: 2, start: 9, fill: yellow.A),))),
      (5, (range: (0, 3), highlights: (
            (line: 3, end: 3, fill: green.A),
            (line: 3, start: 5, end: 7, fill: yellow.A),
            (line: 3, start: 9, end: 11, fill: red.A),
            (line: 3, start: 13, fill: blue.A),))),
      ("6-", ()),
    ){
      only(slide)[
        #codly(..args)
        #local(number-format: none)[
          ```ocaml
[7;  1;  2;  8]
[7;  1] [2;  8]
[7] [1] [2] [8]
          ```
        ]
      ]
    }
    #v(-0.5em)
    #for (slide, args) in (
      ("6-7", (range: (0, 1), highlights: (
            (line: 1, end: 3, fill: green.A),
            (line: 1, start: 5, end: 7, fill: yellow.A),))),
      ("8", (range: (0, 1), highlights: (
            (line: 1, end: 3, fill: green.A),
            (line: 1, start: 7, end: 7, fill: yellow.A),))),
      ("9-10", (range: (0, 1), highlights: (
            (line: 1, start: 9, end: 11, fill: green.A),
            (line: 1, start: 13, end: 15, fill: yellow.A),))),
      ("11", (range: (0, 1), highlights: (
            (line: 1, start: 11, end: 11, fill: green.A),
            (line: 1, start: 13, end: 15, fill: yellow.A),))),
      ("12-13", (range: (0, 2), highlights: (
            (line: 2, end: 7, fill: green.A),
            (line: 2, start: 9, fill: yellow.A),))),
      ("14-15", (range: (0, 2), highlights: (
            (line: 2, start: 6, end: 7, fill: green.A),
            (line: 2, start: 9, fill: yellow.A),))),
      ("16-17", (range: (0, 2), highlights: (
            (line: 2, start: 6, end: 7, fill: green.A),
            (line: 2, start: 14, fill: yellow.A),))),
      ("18", (range: (0, 2), highlights: (
            (line: 2, start: 7, end: 7, fill: green.A),
            (line: 2, start: 14, fill: yellow.A),))),
      (19, (range: (0, 3))),
    ){
      only(slide)[
        Merge
        #v(-0.5em)
        #local(number-format: none, ..args)[
          ```ocaml
  [7] [1] [2] [8]
  [1;  7] [2;  8]
  [1;  2;  7;  8]
          ```
        ]
      ]
    }
  ][
    #v(-1em)
    #for (slide, hi) in (
      (1, ((line: 1),)),
      (2, ((line: 4),)),
      (3, ((line: 5, fill: green.A), (line: 6, fill: yellow.A))),
      (4, ((line: 7, start: 12, end: 18, fill: green.A), (line: 7, start: 21, end: 27, fill: yellow.A))),
      (5, ((line: 2),)),
    ){
      only(slide)[
        #codly(highlights: hi)
        ```ocaml
let rec sort = function
  | ([] | [ _ ]) as l -> l
  | l ->
    let mid = (len l) / 2 in
    let lh = take mid l in
    let rh = drop mid l in
    merge (sort lh, sort rh)
        ```
      ]
    }
    #for (slide, hi) in (
      (6, ((line: 2, start: 5, end: 20, fill: green.A),
           (line: 3, start: 5, end: 20, fill: yellow.A))),
      (7, ((line: 6, start: 10, end: 10, fill: yellow.A),
           (line: 6, start: 22, end: 23, fill: green.A),
           (line: 6, start: 26, end: 28, fill: yellow.A))),
      (8, ((line: 7, start: 10, end: 11, fill: yellow.A),
           (line: 7, start: 5, end: 7, fill: green.A),
           (line: 7, start: 26, end: 28, fill: green.A))),
      (9, ((line: 2, start: 5, end: 20, fill: green.A),
           (line: 3, start: 5, end: 20, fill: yellow.A))),
      (10, ((line: 5, start: 10, end: 10, fill: green.A),
            (line: 5, start: 22, end: 24, fill: yellow.A),
            (line: 5, start: 27, end: 28, fill: green.A))),
      (11, ((line: 7, start: 15, end: 16, fill: green.A),
            (line: 7, start: 19, end: 21, fill: yellow.A),
            (line: 7, start: 26, end: 28, fill: yellow.A))),
      (12, ((line: 2, start: 5, end: 20, fill: green.A),
           (line: 3, start: 5, end: 20, fill: yellow.A))),
      (13, ((line: 5, start: 10, end: 10, fill: green.A),
            (line: 5, start: 22, end: 24, fill: yellow.A),
            (line: 5, start: 27, end: 28, fill: green.A))),
      (14, ((line: 2, start: 5, end: 20, fill: green.A),
           (line: 3, start: 5, end: 20, fill: yellow.A))),
      (15, ((line: 6, start: 10, end: 10, fill: yellow.A),
           (line: 6, start: 22, end: 23, fill: green.A),
           (line: 6, start: 26, end: 28, fill: yellow.A))),
      (16, ((line: 2, start: 5, end: 20, fill: green.A),
           (line: 3, start: 5, end: 20, fill: yellow.A))),
      (17, ((line: 5, start: 10, end: 10, fill: green.A),
            (line: 5, start: 22, end: 24, fill: yellow.A),
            (line: 5, start: 27, end: 28, fill: green.A))),
      (18, ((line: 7, start: 15, end: 16, fill: green.A),
            (line: 7, start: 19, end: 21, fill: yellow.A),
            (line: 7, start: 26, end: 28, fill: yellow.A))),
      (19, ()),
    ){
      only(slide)[
        #codly(highlights: hi)
        ```ocaml
let rec merge = function
  | (x :: xs' as xs),
    (y :: ys' as ys) ->
    if x < y
    then x :: merge (xs', ys)
    else y :: merge (xs, ys')
  | lst, [] | [], lst -> lst
        ```
      ]
    }
  ]
]
