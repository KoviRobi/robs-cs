#import "../0-preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 1],
  subtitle: [OCaml, Where Art Thou]
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

#slide[
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
Because I know it. :p
Simple syntax.
Used in industry
Eager evaluation.

Concepts apply to other FP languages

#note[
  - Eager evaluation: Dynamic programming
  - F♯ is very similar to OCaml
  - ReasonML is/started as an OCaml extension
  - Eager evaluation is one fewer thing to learn on top
]

== Syntax overview
#slide[
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
  #note[
    Simple function definition, body is a single expression. Can be multiple
    with semicolons, and using parentheses or begin/end blocks.

    Double semicolon is for the interpreter, to tell it we have stopped typing.

    Defining product types (pairs/tuples) and sum types (tagged unions). Tagged
    as in an enum indicating kind.

    Pattern matching, to deconstruct types.
  ```
  )
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
#slide[
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
        #sublist(stack)[
          + ```ocaml main```
          + ```ocaml test```, returns to line 5
            + ```ocaml i = 123```
          + ```ocaml print_int```, returns to line 3
            + ```ocaml i = 123```
        ]
      ]
    ]
  }
  #v(-0.5em)
  But most values are boxed, so heap allocated
]

#slide[
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
        #sublist(stack)[
          + main
          + ```ocaml test```, returns to line 5
            + ```ocaml f = ```$angle.l"pointer to heap"angle.r$
          + ```ocaml print_float```, returns to line 3
            + ```ocaml x = ```$angle.l"pointer to heap"angle.r$
        ]
      ]
    ]
  }
  #v(-0.5em)
  But most values are boxed, so heap allocated
]


== Operators
#for n in range(1, 7) {
    only(n, sublist(n)[
      - Integer arithmetic ```ocaml +```, ```ocaml -```, ```ocaml *```, ```ocaml /```,
        - Note: floating-point versions ```ocaml +.```, ```ocaml -.```,
          ```ocaml *.```, ```ocaml /.```
        - Note: explicit prefix ```ocaml ~- ``` and ```ocaml ~-.```
      - String append ```ocaml ^```
      - Equality ```ocaml =``` and ```ocaml <>```, comparison ```ocaml <```, ```ocaml <=```, ```ocaml >```,
        ```ocaml >=```
        - Note, physical equality ```ocaml ==``` and ```ocaml !``````ocaml=```
          (ligature ```ocaml !=```), and structural equality ```ocaml =```
          and ```ocaml <>```
  ])
}

#note[
- Main thing to consider here is equals/not-equals, and explicit prefix.
- See "The OCaml Manual" chapter 11 "The OCaml language" section 7
  "Expressions" subsections 1 "Precedence and associativity" and 5 "Operators"
  for more details.
]
