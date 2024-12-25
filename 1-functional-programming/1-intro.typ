#import "@preview/touying:0.5.3" as touying: *
#import "../unistra/unistra.typ" as unistra: *
#import "../unistra/colors.typ": *
#import "../unistra/admonition.typ": *

#import "../codly/codly.typ": *
#import "@preview/codly-languages:0.1.3": *
#import "../diagraph/lib.typ" as diagraph

#import "../utils.typ": *

// '<,'>!ocamlformat - --impl

#show: codly-init.with()
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS 1],
    subtitle: [OCaml, Where Art Thou],
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

#unistra.slide[
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
#unistra.slide[

  Because I know it. :p

  Simple syntax.

  Used in industry

  Eager evaluation.

  Concepts apply to other FP languages

  #pdfpc.speaker-note(```
    - Eager evaluation: Dynamic programming
    - F# is very similar to OCaml
    - ReasonML is/started as an OCaml extension
    - Eager evaluation is one fewer thing to learn on top
  ```)
]

== Ergonomics
#unistra.slide[
  OCaml interpreter is minimal:
  / #sym.arrow.r.double: Use `utop`, or an editor + lang server

  Or I have a docker image with Jupyter OCaml
  #pause

  Helpful interpreter commands:
  / `#help;;`: if you forget
  / `#use "file.ml";;`: to load a file
  / `#show thing;;`: to show type, or module contents
]

== MS Windows Setup
#v(-1em)
```
winget install Microsoft.VisualStudioCode
winget install OCaml.opam
```
Restart terminal
#v(-0.5em)
```
opam init
opam --install ocaml-lsp-server odoc ocamlformat utop
code --install-extension ocamllabs.ocaml-platform
```

#hero(image("../images/vs-code/1-ocaml-sandbox-select.png"))
#hero(image("../images/vs-code/2-ocaml-sandbox-selected.png"))
#hero(image("../images/vs-code/3-workspace-settings.png"))
#hero(image("../images/vs-code/4-eval-selection.png"))
#hero(image("../images/vs-code/5-doc-hover.png"))
#hero(image("../images/vs-code/6-tab-completion.png"))

== Syntax overview
#unistra.slide[
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
  #pdfpc.speaker-note(```
    Simple function definition, body is a single expression. Can be multiple
    with semicolons, and using parentheses or begin/end blocks.

    Double semicolon is for the interpreter, to tell it we have stopped typing.

    Defining product types (pairs/tuples) and sum types (tagged unions). Tagged
    as in an enum indicating kind.

    Pattern matching, to deconstruct types.
  ```
  )
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
#unistra.slide[
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
        #sublist([
          + ```ocaml main```
          + ```ocaml test```, returns to line 5
            + ```ocaml i = 123```
          + ```ocaml print_int```, returns to line 3
            + ```ocaml i = 123```
        ], stack)
      ]
    ]
  }
  #v(-0.5em)
  But most values are boxed, so heap allocated
]

#unistra.slide[
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
        #sublist([
          + main
          + ```ocaml test```, returns to line 5
            + ```ocaml f = ```$angle.l"pointer to heap"angle.r$
          + ```ocaml print_float```, returns to line 3
            + ```ocaml x = ```$angle.l"pointer to heap"angle.r$
        ], stack)
      ]
    ]
  }
  #v(-0.5em)
  But most values are boxed, so heap allocated
]
