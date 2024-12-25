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

= Complexity
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
    #v(-0.5em)
    (Note, pseudo-code)
  ]
  #only(3)[
    - Time:
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = xl + yl
    ```
    #v(-0.5em)
    (Note, pseudo-code)
  ]
  #only(4)[
    - Space (note, extra space):
    #v(-0.5em)
    ```ocaml
let rec merge xs ys = match xs, ys with
  | x::xs', y::ys' when x<y -> x::merge xs' ys
  | x::xs', y::ys'          -> y::merge xs ys'
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(5)[
    - Space (note, extra space):
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = match xl, yl with
  | xl>0 && yl>0            -> 1 + merge (xl-1) yl
  | xl>0 && yl>0            -> 1 + merge xl (yl-1)
  | xl=0 || yl=0      -> 0
    ```
    #v(-0.5em)
    (Note, pseudo-code)
  ]
  #only(6)[
    - Space (note, extra space):
    #v(-0.5em)
    ```ocaml
let rec merge xl yl = xl + yl
    ```
    #v(-0.5em)
    (Note, pseudo-code)
  ]
]


#unistra.slide[
  #v(-1em)
  ```ocaml
let rec split n = function x::xs when n>0 ->
    let (a, b) = split (n-1) xs in (x::a, b)
  | xs  -> ([], xs)
  ```
  #v(-0.5em)
  Informally, just walks up to $n$ elements, or the length of the list.
]

#unistra.slide[
  #v(-1em)
  #only(1)[
    ```ocaml
let rec sort = function
  | ([] | [_]) as sorted -> sorted
  | lst -> let a, b = split (List.length lst / 2) lst in
    merge (sort a) (sort b)
    ```
  ]
  #only(2)[
    ```ocaml
let rec sort len =
  | len=0 || len=1       -> 1
  | len -> len + len/2
    sort(len/2) + sort(len/2)
    ```
  ]
  #only(3)[
    ```ocaml
let rec sort len =
  | len=0 || len=1       -> 1
  | len -> 3 * len/2
    2 * (3 * len/4 + sort(len/4))
    ```
  ]
  #only(4)[
    ```ocaml
let rec sort len =
  | len=0 || len=1       -> 1
  | len -> 3 * len/2
    3 * len/2 + 2 * sort(len/4)
    ```
    #v(-0.5em)
    Repeated expansion until list length is zero or one, so $log_2("len")$
    expansions.
  ]
  #only(5)[
    ```ocaml
let rec sort len = (3 * len/2) * log_2(len)
    ```
  ]
]
