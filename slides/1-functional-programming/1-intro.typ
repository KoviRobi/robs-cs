#import "../../preamble.typ": *

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

= Course overview
- Functional Programming (OCaml)
  - Linked lists
  - Trees
  - Infinite sequences
  - Garbage collection
- Logic programming
- Types
- Compilers
- Operating Systems


== Why Functional Programming?
- Easier to reason about
- Higher level
- More concise
  - Fits on a slide
- Learn a different way of thinking

== Why OCaml?
- Because I know it :p
- Simple syntax
- Used in industry
- Eager evaluation
- Concepts apply to other FP languages
#note[
  - Eager evaluation: Dynamic programming
  - F♯ is very similar to OCaml
  - ReasonML is/started as an OCaml extension
  - Eager evaluation is one fewer thing to learn on top
]

== Syntax overview
#slide[
  #v(-1em)
  #codly(display-name: true, display-icon: true)
  #only(1)[
    ```ocaml
let greet () = print_endline "Hello, world!";;
    ```
  ]
  #codly(display-name: false, display-icon: false)
  #codly-reveal((0,3,5,7), [
    ```ocaml
let greet () = print_endline "Hello, world!";;

type fruit = Apple | Orange;;

match thing with Apple -> "red" | Orange -> "orange";;

if predicate then true_case else false_case;;
    ```
  ])
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
  #v(-1em)
  #codly-reveal((1, 3, 8))[
    ```ocaml
fun (x, y) -> x + y;;

function Apple -> "red" | Orange -> "orange";;

match arg with
  | (num, min, _) when num < min -> min
  | (num, _, max) when num > max -> max
  | (num, _, _) -> num
    ```
  ]
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

== Infix
#v(-1em)
#codly-reveal((1,3,6,8))[
  ```ocaml
1 + 2;;

( + ) 1 2;;

let ( *@$! ) lhs rhs =
  Printf.printf "%s beautiful %s\n" lhs rhs;;

"This" *@$! "bug";;
  ```
]
#note[
  Perhaps be sparing about defining operators.
]
