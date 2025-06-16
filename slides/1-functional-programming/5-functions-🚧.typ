#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 5],
  subtitle: [Pump Up the #strike[Jam] Fun],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide()

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
let add (args) = match args with
        (x, y) -> x + y
    ```
    ]
#only(4)[
  / #"A:": One
    #v(-0.5em)
    ```ocaml
(* val add :  int * int  -> int *)
let add (args) = match args with
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
let add x y = x + y;;

let add1 = add 1;;

assert (add1 1 = 2);;
assert (add1 (add1 1) = 3);;

assert (List.map (add 10) [1; 2; 3] = [11; 12; 13]);;
```
  ]
]

= Module signatures
Remember, I mentioned ```ocaml #show <module>``` to view module signature
#v(-0.5em)
#local(number-format: none)[
```ocaml
# #show Int;;
module Int : sig
  type t = int
  (* ... *)
  val to_string : t -> string
end
```
]
#v(-0.5em)
Note, by convention `t` refers to the main type of that module

= Generic types
Some functions contain types like ```ocaml 'a```
#v(-0.5em)
#local(number-format: none)[
  ```ocaml
  # #show List;;
  module List :
    sig
      type 'a t = 'a list = [] | (::) of 'a * 'a list
      val length : 'a t -> int
    end
  ```
]
#v(-0.5em)
It is a type parameter -- can be any type

= Higher order functions
#v(-1em)
#local(number-format: none)[
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
]

= Utility functions
#v(-1em)
#local(number-format: none)[
```ocaml
# #show Fun;;
module Fun : sig
  external id : 'a -> 'a = "%identity"
  val const : 'a -> 'b -> 'a
  val compose : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
  val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
  val negate : ('a -> bool) -> 'a -> bool
end
```
]

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
