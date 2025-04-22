#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 2],
  subtitle: [Linked Lists],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

= Linked Lists
#slide[
  #v(-1em)
  #only(1)[
    ```ocaml
type 'a list = [] | ( :: ) of 'a * ('a list)
    ```
  ]
  #only(4)[
    #codly(display-name: false, display-icon: false)
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let l = 1 :: (2 :: (3 :: []))
    ```
  ]
  #only(5)[
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let l = 1 :: 2 :: 3 :: []
    ```
  ]
  #codly-reveal((0,1,3,0,0,8))[
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let l = [1; 2; 3]

let rec append (xs, ys) =
  match xs with
  | [] -> ys
  | x :: xs' -> x :: append (xs', ys)
    ```
  ]
  #only("3-5")[
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

== Looping
#slide[
  #codly(display-name: true, display-icon: true)
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
  #codly(display-name: false, display-icon: false)
]

== Recursion
#slide[
  #v(-1em)
  #codly-reveal((3,7))[
    ```ocaml
let rec fold_left (f, acc, lst) = match lst with
  | [] -> acc
  | l :: ls -> fold_left (f, f (acc, l), ls)

let rec fold_right (f, lst, acc) = match lst with
  | [] -> acc
  | l :: ls -> f (l, fold_right (f, ls, acc))
    ```
  ]
  #pdfpc.speaker-note(```
    Fundamental list operation.
  ```)
]

#slide[
  #v(-1em)
  ```ocaml
fold_left  ( (fun (a, b) -> a + b),   0, [1; 2; 3])
  = 6;;


fold_right ( (fun (a, b) -> a + b),  [1; 2; 3],  0)
  = 6;;
  ```
]

#slide[
  #v(-1em)
  ```ocaml
fold_left  ( (fun (a, b) -> b :: a), [], [1; 2; 3])
  = [3; 2; 1];;


fold_right ( (fun (a, b) -> a :: b), [1; 2; 3], [])
  = [1; 2; 3];;
  ```
]

== Recursion -- Example
#slide[
  #v(-1em)
  #let foldr = [
    ```ocaml
let rec foldr (f, lst, acc) =
  match lst with
  | [] -> acc
  | l::ls ->
    f (l, foldr (f, ls, acc))
    ```
  ]
  #let entries = (
    ((line: 2, start: 3, end: 16), 1),
    ((line: 4, start: 3, end: 12), 1),
    ((line: 5, start: 5, end: 29), 2),

    ((line: 2, start: 3, end: 16), 3),
    ((line: 4, start: 3, end: 12), 3),
    ((line: 5, start: 5, end: 29), 4),

    ((line: 2, start: 3, end: 16), 5),
    ((line: 4, start: 3, end: 12), 5),
    ((line: 5, start: 5, end: 29), 6),

    ((line: 2, start: 3, end: 16), 7),
    ((line: 3, start: 3, end: 13), 7),
  )
  #components.side-by-side(columns: (3fr, 2fr))[
    #for (slide, (hi, stack)) in entries.enumerate(start: 1) {
      only((slide,))[
        #codly(highlights: (hi,))
        #foldr
      ]
    }
    #only(range(entries.len() + 1, entries.len() + 5))[
      #codly(highlights: ((line: 5, start: 5, end: 29),))
      #foldr
    ]
  ][
    #for (slide, (hi, stack)) in entries.enumerate(start: 1) {
      only(slide,)[
        #sublist(stack)[
          + ```ocaml foldr (+) [1;2;3] 0```
            + line 5 ```ocaml (+) 1 _```
          + ```ocaml foldr (+) [2;3]   0```
            + line 5 ```ocaml (+) 2 _```
          + ```ocaml foldr (+) [3]     0```
            + line 5 ```ocaml (+) 3 _```
          + ```ocaml foldr (+) []      0```
        ]
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
    #only(entries.len() + 4,)[
      + ```ocaml 6```
    ]
  ]
]

== Tail Recursion
#slide[
  #v(-1em)
  #components.side-by-side(columns: (3fr, 2fr))[
    #for (slide, hi) in (
      (line: 2, start: 3, end: 16),
      (line: 4, start: 3, end: 12),
      (line: 5, start: 5, end: 29),

      (line: 2, start: 3, end: 16),
      (line: 4, start: 3, end: 12),
      (line: 5, start: 5, end: 29),

      (line: 2, start: 3, end: 16),
      (line: 4, start: 3, end: 12),
      (line: 5, start: 5, end: 29),

      (line: 2, start: 3, end: 16),
      (line: 3, start: 3, end: 13),
    ).enumerate(start: 1) {
    only(slide)[
      #codly(highlights: (hi,))
        ```ocaml
let rec foldl (f, acc, lst) =
  match lst with
  | [] -> acc
  | l::ls ->
    foldl (f, f (acc, l), ls)
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

== Merge-sort
#slide[
  #components.side-by-side(columns: (2fr, 3fr))[
    #v(-1em)
    Split
    #v(-0.5em)
    #local(number-format: none)[
      #codly-reveal((1,2,3,3,3,3))[
        ```ocaml
[7;  1;  2;  8]
[7;  1] [2;  8]
[7] [1] [2] [8]
        ```
      ]
    ]
    #v(-0.5em)
    #only("4-")[Merge]
    #v(-0.5em)
    #local(number-format: none)[
      #codly-reveal((0,0,0,1,2,3))[
        ```ocaml
[7] [1] [2] [8]
[1;  7] [2;  8]
[1;  2;  7;  8]
        ```
      ]
    ]
  ][
    #v(-1em)
    #only(1)[
      ```ocaml
let rec sort = function

  | l ->
    let mid = (len l) / 2 in




      ```
    ]
    #only(2)[
      ```ocaml
let rec sort = function

  | l ->
    let mid = (len l) / 2 in
    let lh = take mid l in
    let rh = drop mid l in


      ```
    ]
    #only(3)[
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
    #only(4)[
      ```ocaml
let rec merge = function
  | (x :: ...      ),
    (y :: ...      ) ->
    if x < y
    then x :: ...
    else y :: ...


      ```
    ]
    #only(5)[
      ```ocaml
let rec merge = function
  | (x :: xs' as xs),
    (y :: ys' as ys) ->
    if x < y
    then x :: merge (xs', ys)
    else y :: merge (xs, ys')


      ```
    ]
    #only(6)[
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
  ]
]

== Coding practice
Implement ```ocaml take``` and ```ocaml drop```.
#v(-0.5em)
```ocaml
val take : (int * 'a list) -> 'a list
val drop : (int * 'a list) -> 'a list
```
#v(-0.5em)
Some structure is provided at
#v(-0.5em)
```sh
git clone https://github.com/KoviRobi/robs-cs
git checkout exercises/1-mergesort
dune runtest
```

#hero(image("../../images/vs-code/7-clone-repo.png"))
#hero(image("../../images/vs-code/8-checkout-branch.png"))
#hero(image("../../images/vs-code/9-ml-interface.png"))
#hero(image("../../images/vs-code/10-ml-implementation.png"))
#hero(image("../../images/vs-code/11-dune-runtest.png"))
