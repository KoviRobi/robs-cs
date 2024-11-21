#import "@preview/touying:0.5.3": *
#import "unistra/unistra.typ": *
#import "unistra/colors.typ": *
#import "unistra/admonition.typ": *

#import "@preview/codly:1.0.0": *

#show: codly-init.with()
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS],
    subtitle: [_Functional Programming_],
    author: [Robert Kovacsics],
    date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
    logo: image(width: 80%, "branding/carallon/carallon_logo_white.png"),
  ),
  config-common(show-notes-on-second-screen: right,
    preamble: {
      codly(
        languages: (
          ml: (
            name: "OCaml",
            icon: text(font: "CaskaydiaCove NF")[\u{e67a}#h(0.4em)],
          ),
        ),
        zebra-fill: luma(251),
        lang-fill: (lang) => lang.color.lighten(95%),
      )
    }
  ),
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide(logo: image("branding/carallon/carallon_logo_white.png"))

= OCaml
== Why OCaml?
#slide[

  Because I know it. :p

  Simple syntax.

  Eager evaluation.

  Paradigm over syntax.

  #speaker-note[
    / Eager evaluation: Dynamic programming
    / Paradigm: Is the difficult bit, different syntax e.g. F#sym.sharp easy to
      learn on top. Haskell is a bit more difficult on top, as it is lazy, but
      it is a pretty language.
  ]
]

== Ergonomics
#slide[
  OCaml interpreter is barebones:
  / #sym.arrow.r.double: Use `utop`, or an editor + lang server

  Or I have a docker image with Jupyter OCaml
  #pause

  Helpful interpreter commands:
  / `#help;;`: if you forget
  / `#use "file.ml";;`: to load a file
  / `#show thing;;`: to show type, or module contents
]

== Syntax overview
#slide[
  ```ml
  let greet () = print_endline "Hello, world!";;
  ```
  #pause
  ```ml
  type 'a list = Nil | Cons of 'a * 'a list;;
  ```
  #pause
  ```ml
  let rec append x y = match x with
  | Nil -> y
  | Cons(x, xs) -> Cons(x, append xs b)
  ```
  #speaker-note[
    Simple function definition, body is a single expression. Can be multiple
    with semicolons, and using parentheses or begin/end blocks.

    Double semicolon is for the interpreter, to tell it we have stopped typing.

    Defining product types (structs) and sum types (tagged unions).

    Pattern matching, to deconstruct types.
  ]
]

= Floating point
= Complexity

= OCaml
== Type checking
