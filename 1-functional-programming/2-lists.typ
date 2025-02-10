#import "../0-preamble.typ": *

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
  #codly-reveal((0, 1,3,8))[
    ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list

let l = [1; 2]

let rec append xs ys =
  match xs with
  | [] -> ys
  | x :: xs' -> x :: append xs' ys
    ```
  ]
  #only(3)[
    #diagram(
      node((0, 0), box(inset: 0.5em, stroke: black + 1pt, ```ocaml l```)),
      edge("->"),
      node((1, 0), grid(columns: 3, inset: 0.5em, stroke: black + 1pt)[
        ```ocaml ::```][```ocaml 1```][#sym.space.en]),
      edge((rel: (4em, 0mm), to: (1,0)), auto, snap-to: (none, auto), "->"),
      node((2, 0), grid(columns: 3, inset: 0.5em, stroke: black + 1pt)[
        ```ocaml ::```][```ocaml 2```][#sym.space.en]),
      edge((rel: (4em, 0mm), to: (2, 0)), auto, snap-to: (none, auto), "->"),
      node((3, 0), box(inset: 0.5em, stroke: black + 1pt, ```ocaml []```))
    )
  ]
]

== Looping
#slide[
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

== Recursion
#slide[
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

#slide[
  #v(-1em)
  ```ocaml
fold_left  ( + ) 0 [ 1; 2; 3 ]
  = 6;;

fold_right ( + ) [ 1; 2; 3 ] 0
  = 6;;
  ```
]

#slide[
  #v(-1em)
  #local(display-name: false, display-icon: false)[
    ```ocaml
fold_left  (fun a b -> b :: a) [] [ 1; 2; 3; 4; 5 ]
  = [5;4;3;2;1];;

fold_right (fun a b -> a :: b) [ 1; 2; 3; 4; 5 ] []
  = [1;2;3;4;5];;
    ```
  ]
]

== Recursion -- Example
#slide[
  #v(-1em)
  #let foldr = local(display-name: false, display-icon: false)[
    ```ocaml
let rec foldr f lst acc =
  match lst with
  | [] -> acc
  | l::ls ->
    f l (foldr f ls acc)
    ```
  ]
  #let entries = (
    ((line: 2, start: 3, end: 16), 1),
    ((line: 4, start: 3, end: 12), 1),
    ((line: 5, start: 5, end: 25), 2),

    ((line: 2, start: 3, end: 16), 3),
    ((line: 4, start: 3, end: 12), 3),
    ((line: 5, start: 5, end: 25), 4),

    ((line: 2, start: 3, end: 16), 5),
    ((line: 4, start: 3, end: 12), 5),
    ((line: 5, start: 5, end: 25), 6),

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
    #only(range(entries.len() + 1, entries.len() + 4))[
      #codly(highlights: ((line: 4, start: 5, end: 25),))
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
  ]
]

== Tail Recursion
#slide[
  #codly(display-name: false, display-icon: false)
  #v(-1em)
  #components.side-by-side(columns: (3fr, 2fr))[
    #for (slide, hi) in (
      (line: 2, start: 3, end: 16),
      (line: 4, start: 3, end: 12),
      (line: 5, start: 5, end: 25),

      (line: 2, start: 3, end: 16),
      (line: 4, start: 3, end: 12),
      (line: 5, start: 5, end: 25),

      (line: 2, start: 3, end: 16),
      (line: 4, start: 3, end: 12),
      (line: 5, start: 5, end: 25),

      (line: 2, start: 3, end: 16),
      (line: 3, start: 3, end: 13),
    ).enumerate(start: 1) {
    only(slide)[
      #codly(highlights: (hi,))
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

== Merge-sort
#slide[
  #components.side-by-side(columns: (2fr, 3fr))[
    #v(-1em)
    Split
    #v(-0.5em)
    #local(
      display-name: false,
      display-icon: false,
      number-format: none,
    )[
      ```ocaml
[7;  1;  2;  8]
[7;  1] [2;  8]
[7] [1] [2] [8]
      ```
    ]
    #v(-0.5em)
    #only("4-")[
      Merge
      #v(-0.5em)
      #local(
        display-name: false,
        display-icon: false,
        annotation-format: none,
        number-format: none,
      )[
        ```ocaml
  [7] [1] [2] [8]
  [1;  7] [2] [8]
  [1;  2;  7;  8]
        ```
      ]
    ]
  ][
    #v(-1em)
    #only(1)[
      #local(display-name: false, display-icon: false)[
        ```ocaml
let rec sort = function

  | l ->
    let mid = (len l) / 2 in




        ```
      ]
    ]
    #only(2)[
      #local(display-name: false, display-icon: false)[
        ```ocaml
let rec sort = function

  | l ->
    let mid = (len l) / 2 in
    let lh = take mid l in
    let rh = drop mid l in


        ```
      ]
    ]
    #only(3)[
      #local(display-name: false, display-icon: false)[
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
    ]
    #only(4)[
      #local(display-name: false, display-icon: false)[
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
]

== Coding practice
Implement ```ocaml take``` and ```ocaml drop```.
```ocaml
val take : int -> 'a list -> 'a list
val drop : int -> 'a list -> 'a list
```
