#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 6],
  subtitle: [Learning to Type],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide()

= Inferring types -- primitives
#slide[
  #codly(display-icon: false, display-name: false, number-format: none)
  How do we work out types? Take
  #only(1)[
    #v(-0.5em)
    ```ocaml
    1
    ```
    #v(-0.5em)
    This is an integer.
  ]

  #only(2)[
    #v(-0.5em)
    ```ocaml
    "hello"
    ```
    #v(-0.5em)
    This is a string.
  ]
]

= Inferring types -- functions
#slide[
  How do we work out types? Take
  #only((1,2,3,4))[
    #v(-0.5em)
    ```ocaml
    let f (x: int) = x
    ```
    #v(-0.5em)
    This is a function.
  ]
  #only((2,3,4))[

    Functions have some argument type, and some return type.
  ]
  #only((3,4))[

    It takes ```ocaml x```, an ```ocaml int```, and returns the type of
    ```ocaml x```.
  ]
  #only((4))[

    It is ```ocaml int -> int```.
  ]

  #only((5,6,7,8))[
    #v(-0.5em)
    ```ocaml
    let f x = x
    ```
    #v(-0.5em)

    Also a function.
  ]
  #only((6,7,8))[

    But here ```ocaml x``` is generic.
  ]
  #only((7,8))[

    So assume it has type ```ocaml 'a```.
  ]
  #only((8))[

    Thus it has type ```ocaml 'a -> 'a```.
  ]

  #only((9,10,11))[
    #v(-0.5em)
    ```ocaml
    let rec f x = f x
    ```
    #v(-0.5em)
  ]
  #only((10,11))[

    If it never terminates, it could return anything.
  ]
  #only((11))[

    So ```ocaml 'a -> 'b```.
  ]
]

= Inferring types -- application
#slide[
  How do we work out types? Take
  #only((1,2,3,4))[
    #v(-0.5em)
    ```ocaml
    (fun x -> x) 1
    ```
    #v(-0.5em)
    This is a function application.
  ]
  #only((2,3,4))[

    We know the function is ```ocaml 'a -> 'a```.
  ]
  #only((3,4))[

    We also know the argument is ```ocaml int```.
  ]
  #only(4)[

    But then ```ocaml 'a``` is ```ocaml int```.

    So the result is ```ocaml int```.
  ]

  #only((5,6))[
    #v(-0.5em)
    ```ocaml
    x y
    ```
    #v(-0.5em)
    We have to assume ```ocaml x``` is a generic function.

    So try ```ocaml x``` as ```ocaml 'a -> 'b```.
  ]
  #only((6))[

    Then ```ocaml y``` should be ```ocaml 'a```.

    And ```ocaml x y``` should be ```ocaml 'b```.
  ]
]
= Inferring types -- datatypes
#slide[
  How do we work out types? Take
  #only((1,2))[
    #v(-0.5em)
    ```ocaml
    type 'a mylist = Empty | Cons of 'a * 'a mylist;;
    Empty
    ```
    #v(-0.5em)
  ]
  #only(2)[
    We see ```ocaml Empty``` takes no arguments.

    Once all arguments are applied, it must be ```ocaml 'a mylist```.
  ]

  #only((3,4))[
    #v(-0.5em)
    ```ocaml
    type 'a mylist = Empty | Cons of 'a * 'a mylist;;
    Cons(1, Empty)
    ```
    #v(-0.5em)
  ]
  #only((4))[
    We see ```ocaml Cons``` takes ```ocaml 'a * 'a mylist```

    We know ```ocaml 1``` is ```ocaml int``` and ```ocaml Empty``` is
    ```ocaml 'a mylist```.

    So ```ocaml Cons(1, Empty)``` is ```ocaml int mylist```.
  ]
]

= Inferring types -- example
#let isorec(range) = [
  #v(-0.5em)
  #local(range: range)[
    ```ocaml
    type 'a box = Box of ('a box -> 'a)
    let unbox (Box x) = x
    let crowbar x = unbox x x
    let task = crowbar (Box crowbar)
    ```
  ]
  #v(-0.5em)
]
#only((1))[
We will work through this complicated example
#isorec(none)
]
Let's go function by function
#only((2,3))[
  #isorec((1, 2))
  We know ```ocaml Box x``` as ```ocaml 'a box``` means ```ocaml x : 'a box -> 'a```.

]
#only((2))[
  So ```ocaml unbox``` is a function ```ocaml 'a box -> ('a box -> 'a)```.
]
#only((3))[
  So ```ocaml unbox``` is a function ```ocaml 'a box ->  'a box -> 'a ```.
]
#only((4))[
  #isorec((1, 3))
  For crowbar, assume ```ocaml x``` is some *unused* type
  #v(1fr)
  ```ocaml
  unbox : 'a box -> 'a box -> 'a
  ```
  #v(0.5em)
]
#only((5,6,7))[
  #isorec((1, 3))
  For crowbar, assume ```ocaml x``` is some *unused* type ```'a```. \
]
#only((6,7))[
  From ```ocaml unbox x x``` we have ```ocaml x``` as ```'b box```, and
  ```ocaml unbox x x``` as ```ocaml 'b```. \
]
#only((7))[
  So ```ocaml crowbar``` is ```ocaml 'b box -> 'b```
]
#only((5,6,7))[
  #v(1fr)
  ```ocaml
  unbox : 'b box -> 'b box -> 'b
  ```
  #v(0.5em)
]
#only((8,9,10))[
  #isorec((1, 4))
]
#only((9,10))[
  We have ```ocaml Box crowbar``` as ```ocaml 'a box``` \
]
#only((10))[
  So ```ocaml task``` is just ```ocaml 'a```?!
]
#only((8,9,10))[
  #v(1fr)
  ```ocaml
  crowbar : 'a box -> 'a
  ```
  #v(0.5em)
]


/*
#slide[
  How do we work out types? Take
  #only((7,8,9))[
    #v(-0.5em)
    ```ocaml
    let rec f x = f x
    ```
    #v(-0.5em)
  ]
  #only((8,9))[

    If it never terminates, it could return anything.
  ]
  #only((9))[

    So ```ocaml 'a -> 'b```.
  ]
]

#slide[
  #codly(display-icon: false, display-name: false, number-format: none)
  Example from above
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
*/
