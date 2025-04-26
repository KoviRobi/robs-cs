#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 5],
  subtitle: [Trees: They Are Us. Treeeeeeeeees],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

#let tree(a,b,c,d,e,f,g) = diagram(
  spacing: (0.2em, 0.8em),
  node-stroke: 1pt + black,
  node(( 0, 0), a, name: <t0_0>),
  edge(<t0_0>, <t0_1>, "->"),
    node((-4, 1), b, name: <t0_1>),
    edge(<t0_1>, <t0_3>, "->"),
      node((-6, 2), c, name: <t0_3>),
    edge(<t0_1>, <t0_4>, "->"),
      node((-2, 2), d, name: <t0_4>),
  edge(<t0_0>, <t0_2>, "->"),
    node(( 4, 1), e, name: <t0_2>),
    edge(<t0_2>, <t0_5>, "->"),
      node(( 2, 2), f, name: <t0_5>),
    edge(<t0_2>, <t0_6>,"->"),
      node(( 6, 2), g, name: <t0_6>))
#let t1 = tree("0","1","3","4","2","5","6")

= Trees
You've been outside. You know what a tree looks like:
#pause
#v(-0.5em)
```ocaml
type 'a tree = Lf
             | Br of 'a * 'a tree * 'a tree
  ```
#pause
#codly(display-icon: false, display-name: false)
#components.side-by-side(columns: (3fr, 2fr))[
  #v(-0.5em)
  #local(offset: 2)[
    ```ocaml
Br(0, Br(1, Br(3, Lf, Lf),
            Br(4, Lf, Lf)),
      Br(2, Br(5, Lf, Lf),
            Br(6, Lf, Lf)))
    ```
  ]
][
  #align(center, v(-0.5em) + t1)
  #note[
    Not illustrating leaves and keeping branches short for brevity.
  ]
]

== Trees to list
#components.side-by-side(columns: (3fr, 2fr))[
  #v(-1em)
  #local(display-icon: false, display-name: false)[
    #alternatives[
      ```ocaml
let rec preord = function
  | Lf -> []
  | Br(v, l, r) ->
    [v] @ preord l @ preord r
      ```
    ][
      ```ocaml
let rec inord = function
  | Lf -> []
  | Br(v, l, r) ->
    inord l @ [v] @ inord r
      ```
    ][
      ```ocaml
let rec postord = function
  | Lf -> []
  | Br(v, l, r) ->
  postord r @ postord l @ [v]
      ```
    ]
  ]
][
  #t1

  #alternatives[
    0; 1; 2; 3; 4; 5; 6
  ][
    3; 1; 4; 0; 5; 2; 6
  ][
    6; 5; 2; 4; 3; 1; 0
  ]
]
#only((4,5))[
  / #"Q:" : What's wrong with these?
]
#only(5)[
  / #"A:" : Inefficient; using append/`@` means $O(n^2)$ time
]

== Accumulators
#components.side-by-side(columns: (3fr, 2fr))[
  #v(-1em)
  #local(display-icon: false, display-name: false)[
    #alternatives[
      ```ocaml
let preord tree =
  let rec inner acc = function
    | Lf -> acc
    | Br(v, l, r) ->
    v :: inner (inner acc r) l
  in inner [] tree
      ```
    ][
      ```ocaml
let inord tree =
  let rec inner acc = function
    | Lf -> acc
    | Br(v, l, r) ->
    inner (v :: inner acc r) l
  in inner [] tree
      ```
    ][
      ```ocaml
let postord tree =
  let rec inner acc = function
    | Lf -> acc
    | Br(v, l, r) ->
    inner (inner (v::acc) l) r
  in inner [] tree
      ```
    ]
  ]
][
  #t1

  #alternatives[
    0; 1; 2; 3; 4; 5; 6
  ][
    3; 1; 4; 0; 5; 2; 6
  ][
    6; 5; 2; 4; 3; 1; 0
  ]
]
Use an accumulator

== Search trees
#let t2 = tree("3","1","0","2","5","4","6")
Store values ordered according to in-order walk
#v(-0.5em)
#components.side-by-side(columns: (2fr, 3fr))[
  - i.e. $"LHS" < "V" < "RHS"$
  #align(center, t2)
  #pause
  Allows for binary search
][
  #pause
  #alternatives[
    ```ocaml
let rec has el = function
  | Lf -> false
  | Br(v, l, r) ->
    el == v || if el < v
    then has el l
    else has el r
    ```
  ][
    ```ocaml
let rec insert el = function
  | Lf -> Br(el, Lf, Lf)
  | Br(v, l, r) when el < v ->
    Br(v, insert el l, r)
  | Br(v, l, r) when el > v ->
    Br(v, l, insert el r)
  | tree -> tree
    ```
  ]
]

== Balance
#v(-1em)
#components.side-by-side(columns: (3fr, 4fr))[
  #alternatives[
    ```ocaml
insert 4
 (insert 3
  (insert 2
   (insert 1
    (insert 0 Lf))))
    ```
  ][
    ```ocaml
insert 0 Lf
|> insert 1
|> insert 2
|> insert 3
|> insert 4
    ```
  ][
    ```ocaml
List.init 5 Fun.id
|> List.fold_left
  (Fun.flip insert)
  Lf
    ```
  ]
][
  #only(4)[
  #diagram(
    spacing: (0.2em, 0.8em),
    node-stroke: 1pt + black,
    node((0, 0), "0"),
    edge("->"),
    edge((0, 0), (-1, 1), "->"),
      node((1, 1), "1"),
      edge("->"),
      edge((1, 1), (0, 2), "->"),
        node((2, 2), "2"),
        edge("->"),
        edge((2, 2), (1, 3), "->"),
          node((3, 3), "3"),
          edge("->"),
          edge((3, 3), (2, 4), "->"),
            node((4, 4), "4"),
            edge((4, 4), (3, 5), "->"),
            edge((4, 4), (5, 5), "->"))
  ]
]

== Tree rotations
#only((1,2))[
Following trees have the same in-order walk
  #grid(columns: (1fr, 1fr))[
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "D"),
      edge("->"),
        node((-1, 1), "B"),
        edge("->"),
          node((-1.8, 2), "A"),
        edge((-1, 1), (-0.2, 2), "->"),
          node((-0.2, 2), "C"),
      edge((0, 0), (1, 1), "->"),
        node((1, 1), "E"),
    ))
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "B"),
      edge("->"),
        node((-1, 1), "A"),
      edge((0, 0), (1, 1), "->"),
        node((1, 1), "D"),
        edge("->"),
          node((0.2, 2), "C"),
        edge((1, 1), (1.8, 2), "->"),
          node((1.8, 2), "E"),
    ))
  ]
]
#only(2)[
  - Can use to re-balance trees
  - Currently neither are more balanced
    - Look deeper
]
#let rotll(maybeRed) = diagram(
  spacing: (-0.1em, 0.6em),
  node-stroke: 1pt + black,
  node((3, -1), "F"),
  edge("->"),
    maybeRed((0, 0), "D"),
    edge("->"),
      maybeRed((-1, 1), "B"),
      edge("->"),
        node(stroke: 0pt, (-1.8, 2), "A"),
      edge((-1, 1), (-0.2, 2), "->"),
        node(stroke: 0pt, (-0.2, 2), "C"),
    edge((0, 0), (1, 1), "->"),
      node(stroke: 0pt, (1, 1), "E"),
  edge((3, -1), (4, 0), "->"),
    node(stroke: 0pt, (4, 0), "G"),
)
#let rotlr(maybeRed) = diagram(
  spacing: (-0.1em, 0.6em),
  node-stroke: 1pt + black,
  node((3, -1), "F"),
  edge("->"),
    maybeRed((0, 0), "B"),
    edge("->"),
      node(stroke: 0pt, (-1, 1), "A"),
    edge((0, 0), (1, 1), "->"),
      maybeRed((1, 1), "D"),
      edge("->"),
        node(stroke: 0pt, (0.2, 2), "C"),
      edge((1, 1), (1.8, 2), "->"),
        node(stroke: 0pt, (1.8, 2), "E"),
  edge((3, -1), (4, 0), "->"),
    node(stroke: 0pt, (4, 0), "G"),
)
#let rotrl(maybeRed) = diagram(
  spacing: (-0.1em, 0.6em),
  node-stroke: 1pt + black,
  node((-3, -1), "B"),
  edge("->"),
    maybeRed((0, 0), "F"),
    edge("->"),
      maybeRed((-1, 1), "D"),
      edge("->"),
        node(stroke: 0pt, (-1.8, 2), "C"),
      edge((-1, 1), (-0.2, 2), "->"),
        node(stroke: 0pt, (-0.2, 2), "E"),
    edge((0, 0), (1, 1), "->"),
      node(stroke: 0pt, (1, 1), "G"),
  edge((-3, -1), (-4, 0), "->"),
    node(stroke: 0pt, (-4, 0), "A"),
)
#let rotrr(maybeRed) = diagram(
  spacing: (-0.1em, 0.6em),
  node-stroke: 1pt + black,
  node((-3, -1), "B"),
  edge("->"),
    maybeRed((0, 0), "D"),
    edge("->"),
      node(stroke: 0pt, (-1, 1), "C"),
    edge((0, 0), (1, 1), "->"),
      maybeRed((1, 1), "F"),
      edge("->"),
        node(stroke: 0pt, (0.2, 2), "E"),
      edge((1, 1), (1.8, 2), "->"),
        node(stroke: 0pt, (1.8, 2), "G"),
  edge((-3, -1), (-4, 0), "->"),
    node(stroke: 0pt, (-4, 0), "A"),
)
#let rotbal(maybeRed) = diagram(
  spacing: (0.2em, 0.6em),
  node-stroke: 1pt + black,
  maybeRed((0, 0), "D"),
  edge("->"),
    node((-1, 1), "B"),
    edge("->"),
      node(stroke: 0pt, (-1.8, 2), "A"),
    edge((-1, 1), (-0.6, 2), "->"),
      node(stroke: 0pt, (-0.6, 2), "C"),
  edge((0, 0), (1, 1), "->"),
    node((1, 1), "F"),
    edge("->"),
      node(stroke: 0pt, (0.6, 2), "E"),
    edge((1, 1), (1.8, 2), "->"),
      node(stroke: 0pt, (1.8, 2), "G"),
)
#only((3))[
  #v(-1em)
  #grid(columns: (1fr, 1fr, 1fr, 1fr),
    align(center, rotll(node)),
    align(center, rotlr(node)),
    align(center, rotrl(node)),
    align(center, rotrr(node)))
  #v(-2em)
    #grid(align: center + horizon, columns: (1fr, 1fr, 1fr),
      sym.arrow.r.curve,
      grid(align: center + horizon, columns: 3,
        sym.arrow.r.curve, rotbal(node), sym.arrow.l.curve),
      sym.arrow.l.curve,
    )
  #v(-1em)
]

== Red-black tree
#slide[
  When to apply tree rotation?
  #pause
  #v(-0.5em)
  Red-black trees:
  - Every branch node has a colour, red or black
    - Root and leaves are black
  - Two invariants:
    #pause
    / Invariant 1: No red node has a red child;
      #only("5-")[#h(1fr)#text(fill: red.A, [local property])]
    #pause
    / Invariant 2: Every path from root to leaf has the same number of black
      nodes.
      #only("5-")[#h(1fr)#text(fill: red.A, [global property])]
  #v(-0.5em)
  #only(6)[
  Easier to fix local properties
  ]
]

#slide[
  #let redNode(..args) = node(stroke: (dash: "dashed", thickness: 0.2em, paint: red.B), ..args)
  #alternatives[
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "0"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
    ))
    #v(1fr)
    Easier to insert red node #h(1fr) no red node has a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "0"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        redNode((1, 1), "1"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
    ))
    #v(1fr)
    No need to fix up anything #h(1fr) no red node has a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "0"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        redNode((1, 1), "1"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
          redNode((2, 2), "2"),
          edge((2, 2), (1.5, 3), "->"),
          edge((2, 2), (3, 3), "->"),
    ))
    #v(1fr)
    Need to fix up #h(1fr) a red node has a red child
    #v(1.34em)
  ][
    Remember

    #grid(align: (right, center+horizon, left), columns: (1fr, 1fr, 1fr),
      rotrr(node), sym.arrow.r, rotbal(node))
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      redNode((0, 0), "1"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        node((-1, 1), "0"),
        edge((-1, 1), (-0.5, 2), "->"),
        edge((-1, 1), (-2, 2), "->"),
        redNode((1, 1), "2"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
    ))
    #v(1fr)
    Need to fix up #h(1fr) a red node has a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "1"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        node((-1, 1), "0"),
        edge((-1, 1), (-0.5, 2), "->"),
        edge((-1, 1), (-2, 2), "->"),
        node((1, 1), "2"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
    ))
    #v(1fr)
    Okay #h(1fr) no red node has a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "1"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        node((-1, 1), "0"),
        edge((-1, 1), (-0.5, 2), "->"),
        edge((-1, 1), (-2, 2), "->"),
        node((1, 1), "2"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
          redNode((2, 2), "3"),
          edge((2, 2), (1.5, 3), "->"),
          edge((2, 2), (3, 3), "->"),
    ))
    #v(1fr)
    Okay #h(1fr) no red node has a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "1"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        node((-1, 1), "0"),
        edge((-1, 1), (-0.5, 2), "->"),
        edge((-1, 1), (-2, 2), "->"),
        node((1, 1), "2"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
          redNode((2, 2), "3"),
          edge((2, 2), (1.5, 3), "->"),
          edge((2, 2), (3, 3), "->"),
            redNode((3, 3), "4"),
            edge((3, 3), (2.5, 4), "->"),
            edge((3, 3), (4, 4), "->"),
    ))
    #v(1fr)
    Need to fix up #h(1fr) a red node has a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "1"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        node((-1, 1), "0"),
        edge((-1, 1), (-0.5, 2), "->"),
        edge((-1, 1), (-2, 2), "->"),
        node((1, 1), "3"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
          redNode((0.5, 2), "2"),
          edge((0.5, 2), (0, 3), "->"),
          edge((0.5, 2), (1, 3), "->"),
          redNode((2, 2), "4"),
          edge((2, 2), (1.5, 3), "->"),
          edge((2, 2), (3, 3), "->"),
    ))
    #v(1fr)
    Will run into trouble #h(1fr) next red node will have a red child
    #v(1.34em)
  ][
    #align(center, diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node((0, 0), "1"),
      edge((0, 0), (-1, 1), "->"),
      edge((0, 0), (1, 1), "->"),
        node((-1, 1), "0"),
        edge((-1, 1), (-0.5, 2), "->"),
        edge((-1, 1), (-2, 2), "->"),
        redNode((1, 1), "3"),
        edge((1, 1), (0.5, 2), "->"),
        edge((1, 1), (2, 2), "->"),
          node((0.5, 2), "2"),
          edge((0.5, 2), (0, 3), "->"),
          edge((0.5, 2), (1, 3), "->"),
          node((2, 2), "4"),
          edge((2, 2), (1.5, 3), "->"),
          edge((2, 2), (3, 3), "->"),
    ))
    #v(1fr)
    Okay #h(1fr) no red node has a red child
    #v(1.34em)
  ][
    Summary
    #v(-0.5em)
    #grid(columns: (1fr, 1fr, 1fr, 1fr),
      align(center, rotll(redNode)),
      align(center, rotlr(redNode)),
      align(center, rotrl(redNode)),
      align(center, rotrr(redNode)))
    #v(-2em)
    #grid(align: center + horizon, columns: (1fr, 1fr, 1fr),
      sym.arrow.r.curve,
      grid(align: center + horizon, columns: 3,
        sym.arrow.r.curve, rotbal(redNode), sym.arrow.l.curve),
      sym.arrow.l.curve,
    )
    #v(-1em)
  ]
]

== Exercise
Code red-black tree versions of `has` and `insert` from eariler.
#v(-0.5em)
#components.side-by-side(columns: (2fr, 3fr))[
  ```ocaml
let rec has el =
  function
  | Lf -> false
  | Br(v, l, r) ->
    el == v ||
    if el < v
    then has el l
    else has el r
```
][
  ```ocaml
let rec insert el = function
  | Lf -> Br(el, Lf, Lf)
  | Br(v, l, r) when el < v ->
    Br(v, insert el l, r)
  | Br(v, l, r) when el > v ->
    Br(v, l, insert el r)
  | tree -> tree
```
]

== Answer
