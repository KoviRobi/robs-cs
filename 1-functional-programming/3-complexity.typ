#import "@preview/touying:0.5.3" as touying: *
#import "../unistra/unistra.typ" as unistra: *
#import "../unistra/colors.typ": *
#import "../unistra/admonition.typ": *

#import "../codly/codly.typ": *
#import "@preview/codly-languages:0.1.3": *

#import "../utils.typ": *

// '<,'>!ocamlformat - --impl

#show: codly-init.with()
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS 3],
    subtitle: [Getting Complex],
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

== Complexity
#unistra.slide[
    - Replace known functions with cost
  #only(1)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xs ys = match xs, ys with
  | x::xs', y::ys' when x<y -> x::merge xs' ys
  | x::xs', y::ys'          -> y::merge xs ys'
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(2)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = match xl, yl with
  | xl>0 && yl>0            -> 1 + merge (xl-1) yl
  | xl>0 && yl>0            -> 1 + merge xl (yl-1)
  | xl=0 || yl=0      -> 1
    ```
  ]
  #only(3)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = xl + yl
    ```
  ]
  #only(4)[
    - Space:
    #v(-0.5em)
    ```ocaml
let rec merge xs ys = match xs, ys with
  | x::xs', y::ys' when x<y -> x::merge xs' ys
  | x::xs', y::ys'          -> y::merge xs ys'
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(5)[
    - Space:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = match xl, yl with
  | xl>0 && yl>0            -> 1 + merge (xl-1) yl
  | xl>0 && yl>0            -> 1 + merge xl (yl-1)
  | xl=0 || yl=0      -> 1
    ```
  ]
  #only(6)[
    - Space (note, extra space):
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = xl + yl
    ```
  ]
]

TODO: Turns out the merge-sort implementation is naive -- not $O(n log n)$, due
to ```ocaml List.length```, and splitting list? Lecture notes only discuss
complexity in terms of number of comparisons.
