#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 5],
  subtitle: [Fun to Type],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

= Multiple arguments
#slide[
/ #"Q:": How many arguments do OCaml functions take
#pause
#only(2)[
  / #"A:": One
]
#only(3)[
  / #"A:": One
    #v(-0.5em)
    ```ocaml
(* val add : (int * int) -> int *)
let add (x__y) = match x__y with
        (x, y) -> x + y
    ```
    ]
#only(4)[
  / #"A:": One
    #v(-0.5em)
    ```ocaml
(* val add :  int * int  -> int *)
let add (x__y) = match x__y with
        (x, y) -> x + y
    ```
    ]
#only(5)[
  / #"A:": One, with pattern matching
    #v(-0.5em)
    ```ocaml
(* val add :  int * int  -> int *)
let add (x, y) = x + y
    ```
  ]
]

#slide[
/ #"Q:": So what's
  #v(-0.5em)
  ```ocaml
let add x y = x + y
  ```
#pause
/ #"A:": Function returning a function
  #only(2)[
    ```ocaml
(* val add : int -> (int -> int) *)
let add = fun x -> (fun y -> x + y)
    ```
  ]
  #only(3)[
    ```ocaml
(* val add : int ->  int -> int  *)
let add = fun x ->  fun y -> x + y
    ```
  ]
  #only(4)[
    ```ocaml
(* val add : int ->  int -> int  *)
let add x = fun y -> x + y
    ```
  ]
]

#slide[
  / #"Q:": Why use
    #v(-0.5em)
    ```ocaml
let add x y = x + y
    ```
    #v(-0.5em)
    instead of #only(3)[#h(1fr)#sym.arrow.t curry #h(1em) uncurry #sym.arrow.b#h(1fr)]
    #v(-0.5em)
    ```ocaml
let add (x, y) = x + y
    ```
  #pause
  / #"A:": Partial application
]

= Partial application
#slide[
  Contrived but simple example
  #v(-0.5em)
  #codly-reveal((1,3,6,8))[
    ```ocaml
let add x y = x + y

let add1 = add 1

let 2 = add1 1
let 3 = add1 (add1 1)

let [11; 12; 13] = List.map (add 10) [1; 2; 3]
    ```
  ]
]

= Higher order functions
#v(-1em)
```ocaml
# #show List;;
module List : sig
  val map : ('a -> 'b) -> 'a t -> 'b t
  val concat_map : ('a -> 'b t) -> 'a t -> 'b t
  val for_all : ('a -> bool) -> 'a t -> bool
  val exists : ('a -> bool) -> 'a t -> bool
  val filter : ('a -> bool) -> 'a t -> 'a t
  (* ... *)
end
```

== Example -- Transpose
#v(-1em)
#components.side-by-side(columns: (5fr, 2fr))[
  #codly(display-icon: false, display-name: false)
  ```ocaml
  let rec transpose = function
    | []::_ -> []
    | lst ->
      List.map List.hd lst
      :: transpose List.(map tl lst)
  ```
][
  #for (i, (head, t1, t2)) in (
    (0,0,0),
    (0,0,0),
    (3,5,7),
    (5,7,7),
    (7,0,0),
  ).enumerate(start: 1){
    only(i, local(
      number-format: none,
      highlights: (
        (line: 1, start: head, end: head),
        (line: 2, start: head, end: head),
        (line: 3, start: head, end: head),
        (line: 1, start: t1, end: t2, fill: green.B),
        (line: 2, start: t1, end: t2, fill: green.B),
        (line: 3, start: t1, end: t2, fill: green.B),
      ),
    )[
      ```ocaml
      [[1;2;3];
       [4;5;6];
       [7;8;9]]
      ```
    ])
  }
]
#pause
Note: `List.(map tl lst)` behaves like `List.map List.tl lst`

== Example -- Encapsulating state
#slide[
  #v(-1em)
  ```ocaml
let make_counter () =
  let this = ref 0 in
  fun () -> begin
    let old = !this in
    this := !this + 1;
    old
  end
  ```
][
  #pause
  #v(-1em)
  #local(number-format: none)[
    ```ocaml
# let a = make_counter ();;
# let b = make_counter ();;
# a();;
0
# a();;
1
# b();;
0
    ```
  ]
]

= Combinations
#v(-1em)
```ocaml
let rec comb = function
  | [] -> [[]]
  | x :: xs ->
    List.map (fun rest -> x :: rest) (comb xs)
    @ comb xs
```

= Functions all the way down
#slide[
  #align(center, table(columns: 2, stroke: 0em, inset: 0.5em, align: (right, left))[
    C           ][ Everything is a number][
    Bash        ][ Everything is a string][
    Ruby        ][ Everything is an object][
    OCaml       ][ Everything is a function])
]

= Functions as lists
#slide[
  #v(-0.8em)
  #admonition(title: "Warning", primary-color: yellow.E, secondary-color: yellow.D, tertiary-color: yellow.A)[
  This is for learning purposes.

  It is attempted here by a highly trained stunt programmer. 🛹

  Do not try this in production.

  (Do try this at home.)
  ]
]

#slide[
  Remember lists?
  #v(-0.5em)
  ```ocaml
type 'a list = [] | ( :: ) of 'a * 'a list
let empty = []
let cons el lst = el :: lst
  ```
  #pause
  #v(-0.5em)

  #only(2)[
    How about encoding `match lst with ...`?
    #v(-0.5em)
    ```ocaml
let empty = fun ifCons ifEmpty -> ifEmpty
let cons el lst = fun ifCons ifEmpty -> ifCons el lst
    ```
    #v(-0.5em)
    (Scott encoding)
  ]
  #only(3)[
    How about encoding `fold_right`?
    #v(-0.5em)
    ```ocaml
let empty = fun f init -> init
let cons el lst = fun f init -> f el (lst f init)
    ```
    #v(-0.5em)
    (Church encoding)
  ]
  #note[
    Scott encoding is very simple, for each type constructor (e.g. empty list,
    cons), we create a function which takes one function for each case (each
    option in the pattern match) and calls the correct one with the values
    contained in that case.

    Church encoding is only a little more complicated, because here for
    recursive values (e.g. the tail of the list), we call the value contained
    within with the arguments for the current case).
  ]
]

#slide[
  #codly(display-icon: false, display-name: false, number-format: none)
  How do we work out types? Take
  #let mkhi(hi) = local(highlights: hi)[
    #v(-0.5em)
    ```ocaml
let empty = fun ifCons -> fun ifEmpty -> ifEmpty
    ```
    #v(-0.5em)
  ]
  #alternatives[
    #v(-0.5em)
    ```ocaml
let empty = fun ifCons ifEmpty -> ifEmpty
    ```
    #v(-0.5em)
  ][
    #mkhi(none)
    Remember ```ocaml fun a b -> body``` is just shorthand.
  ][
    #mkhi((
      (line: 1, start: 13, end: 15),
      (line: 1, start: 17, end: 48, fill: green.B),
    ))
    Functions must have a function type, i.e.
    #v(-0.5em)
    ```ocaml
(fun arg -> body) : 'argType -> 'bodyType
    ```
    #v(-0.5em)
    So assume `empty` has type ```ocaml 't1 -> 't2```.

    Currently ```ocaml 't1``` and ```ocaml 't2``` could be any type.

    #v(1fr)
    ```ocaml
empty : 't1 -> 't2
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 17, end: 22),))
    The type of ```ocaml ifCons``` must be the same as ```ocaml 't1```.

    Using the type variable ```ocaml 'ifCons``` to denote the type of
    ```ocaml ifCons``` for simplicity.

    #v(1fr)
    ```ocaml
empty : 'ifCons -> 't2
    ```
    #v(1em)
  ][
    #mkhi((
      (line: 1, start: 27, end: 29),
      (line: 1, start: 31, end: 48, fill: green.B),
    ))
    The type ```ocaml 't2``` must be the same as a function type
    ```ocaml 't3 -> 't4```.

    #v(1fr)
    ```ocaml
empty : 'ifCons -> 't3 -> 't4
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 31, end: 37),))
    The type of ```ocaml ifEmpty``` must be the same as ```ocaml 't3```.

    #v(1fr)
    ```ocaml
empty : 'ifCons -> 'ifEmpty -> 't4
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 42, end: 48),))
    The type of ```ocaml ifEmpty``` must be the same as ```ocaml 't4```.

    #v(1fr)
    ```ocaml
empty : 'ifCons -> 'ifEmpty -> 'ifEmpty
    ```
    #v(1em)
  ][
    #mkhi(none)
    We can rename to get
    #v(1fr)
    ```ocaml
empty : 'a -> 'b -> 'b
    ```
    #v(1em)
  ]
]

#slide[
  A more complicated type
  #let mkhi(hi) = local(highlights: hi)[
    #v(-0.5em)
    ```ocaml
let cons = fun el lst f init -> f el (lst f init)
    ```
    #v(-0.5em)
  ]
  #let mkhi2(hi) = local(display-icon: false, display-name: false, highlights: hi)[
    #v(-0.5em)
    ```ocaml
let cons = fun el lst f init -> (f el) ((lst f) init)
    ```
    #v(-0.5em)
]
  #alternatives[
    #v(-0.5em)
    #local(display-icon: false, display-name: false)[
      ```ocaml
let cons el lst = fun f init -> f el (lst f init)
      ```
    ]
    #v(-0.5em)
  ][
    #mkhi(none)
    Remember ```ocaml let f a = body``` is just shorthand.
  ][
    #mkhi((
      (line: 1, start: 12, end: 14),
      (line: 1, start: 16, end: 49, fill: green.B),
    ))
    Assume `cons` has type ```ocaml 't1 -> 't2```.

    #v(1fr)
    ```ocaml
cons : 't1 -> 't2
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 16, end: 17),))
    The type of ```ocaml el``` must be the same as ```ocaml 't1```.

    Using the type variable ```ocaml 'el``` to denote the type of
    ```ocaml el``` for simplicity.

    #v(1fr)
    ```ocaml
cons : 'el -> 't2
    ```
    #v(1em)
  ][
    #mkhi((
      (line: 1, start: 12, end: 14),
      (line: 1, start: 19, end: 49, fill: green.B),
    ))
    The type ```ocaml 't2``` must be the same as a function type
    ```ocaml 't3 -> 't4```.

    #v(1fr)
    ```ocaml
cons : 'el -> 't3 -> 't4
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 19, end: 21),))
    The type of ```ocaml lst``` must be the same as ```ocaml 'lst```.

    #v(1fr)
    ```ocaml
cons : 'el -> 'lst -> 't4
    ```
    #v(1em)
  ][
    #mkhi((
      (line: 1, start: 12, end: 14),
      (line: 1, start: 23, end: 49, fill: green.B),
    ))
    The type ```ocaml 't4``` must be the same as a function type
    ```ocaml 't5 -> 't6```.

    #v(1fr)
    ```ocaml
cons : 'el -> 'lst -> 't5 -> 't6
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 23, end: 23),))
    The type of ```ocaml f``` must be the same as ```ocaml 'f```.

    #v(1fr)
    ```ocaml
cons : 'el -> 'lst -> 'f -> 't6
    ```
    #v(1em)
  ][
    #mkhi((
      (line: 1, start: 12, end: 14),
      (line: 1, start: 25, end: 49, fill: green.B),
    ))
    The type ```ocaml 't6``` must be the same as a function type
    ```ocaml 't7 -> 't8```.

    #v(1fr)
    ```ocaml
cons : 'el -> 'lst -> 'f -> 't7 -> 't8
    ```
    #v(1em)
  ][
    #mkhi(((line: 1, start: 25, end: 28),))
    The type of ```ocaml init``` must be the same as ```ocaml 'init```.

    #v(1fr)
    ```ocaml
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2(none)
    Let's add parentheses to disambiguate.

    #v(1fr)
    ```ocaml
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2((
      (line: 1, start: 33, end: 38),
      (line: 1, start: 40, end: 53, fill: green.B),
    ))
    The expression ```ocaml (f el) ((lst f) init)``` has type
    ```ocaml 't8```. \
    It is a function application, so ```ocaml f el``` must have type
    ```ocaml 't9 -> 't8``` \
    and ```ocaml (lst f) init``` have type ```ocaml 't9```

    #v(1fr)
    ```ocaml
f el : 't9 -> 't8
(lst f) init : 't9
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2((
      (line: 1, start: 34, end: 34),
      (line: 1, start: 36, end: 37, fill: green.B),
    ))
    Another function application, ```ocaml f : 't10 -> 't11``` and
    ```ocaml el : 't10```. \
    We also know ```ocaml f : 'f``` and ```ocaml el : 'el```.

    #v(1fr)
    ```ocaml
f : 'el -> 't11
f el : 't9 -> 't8
(lst f) init : 't9
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2((
      (line: 1, start: 34, end: 34),
      (line: 1, start: 36, end: 37, fill: green.B),
    ))
    We can rewrite that in terms of the type ```ocaml 'f```.

    #v(1fr)
    ```ocaml
'f = 'el -> 't9 -> 't8
(lst f) init : 't9
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2((
      (line: 1, start: 41, end: 47),
      (line: 1, start: 49, end: 52, fill: green.B),
    ))
    More function applications.

    #v(1fr)
    ```ocaml
'f = 'el -> 't9 -> 't8
lst f : 'init -> 't9
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2((
      (line: 1, start: 42, end: 44),
      (line: 1, start: 46, end: 46, fill: green.B),
    ))
    More function applications.

    #v(1fr)
    ```ocaml
'f = 'el -> 't9 -> 't8
lst : 'f -> 'init -> 't9
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2(none)
    So we have the type ```ocaml 'lst```.

    #v(1fr)
    ```ocaml
'f = 'el -> 't9 -> 't8
'lst = 'f -> 'init -> 't9
cons : 'el -> 'lst -> 'f -> 'init -> 't8
    ```
    #v(1em)
  ][
    #mkhi2(none)
    Now we can rewrite the whole type.

  #v(1fr)
  ```ocaml
cons : 'el ->
       (('el -> 't9 -> 't8) -> 'init -> 't9) ->
       ('el -> 't9 -> 't8) ->
       'init ->
       't8
    ```
    #v(1em)
  ][
    #mkhi2(none)
    And rename to get the same result as OCaml.

    #v(1fr)
    ```ocaml
cons : 'a ->
       (('a -> 'b -> 'c) -> 'd -> 'b) ->
       ('a -> 'b -> 'c) ->
       'd ->
       'c
    ```
    #v(1em)
  ]
]

= Exercise
Can you work out the type of the Scott encoded ```ocaml cons```?
(It is much simpler than the Church encoded ```ocaml cons```.)

#v(-0.5em)
```ocaml
let cons el lst = fun ifCons ifEmpty -> ifCons el lst
```

= Answer
#v(-1em)
```ocaml
let cons el lst = fun ifCons ifEmpty -> ifCons el lst
```
#v(-0.5em)
#pause
First we know it is a curried function of four arguments
#v(-0.5em)
```ocaml
cons : 'el -> 'lst -> 'ifCons -> 'ifEmpty -> 't1
```
#v(-0.5em)
#pause
Then we know ```ocaml ifCons``` is a curried function of two arguments.
#v(-0.5em)
```ocaml
'ifCons = 'el -> 'lst -> 't1
```
#v(-0.5em)
#pause
So we get
#v(-0.5em)
```ocaml
cons : 'el -> 'lst -> ('el -> 'lst -> 't1) -> 'ifE -> 't1
```
#v(-0.5em)
