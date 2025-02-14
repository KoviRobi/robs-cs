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
    title: [Rob's CS 4],
    subtitle: [Learning to Type],
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

= Infix operators
#unistra.slide[
- Already know
  - Arithmetic: integer ```ocaml +```, ```ocaml -```, ```ocaml *```, ```ocaml /```;
    floating point ```ocaml +.```, ```ocaml -.```, ```ocaml *.```, ```ocaml /.```
    #pause
  - Equality: deep ```ocaml =```, ```ocaml <>```; shallow ```ocaml ==```, ```ocaml !=```;
    comparisons ```ocaml <```, ```ocaml <=```, ```ocaml >```, ```ocaml >=```
    #pause
  - List cons ```ocaml ::``` and append ```ocaml @```
  #pause
  - String append ```ocaml ^```
  #pause
- New: function application ```ocaml @@``` and reverse application ```ocaml |>```
  #v(-0.5em)
  ```ocaml
let ( @@ ) f x = f x
let ( |> ) x f = f x
  ```
  #v(-0.5em)
]
#unistra.slide[
  #v(-1em)
  ```ocaml
let a = foo (bar (baz (quux arg)))

let b = foo @@ bar @@ baz @@ arg

let c = arg |> baz |> bar |> foo
  ```
]

= Types
#unistra.slide[
  But first, a difficult problem. Linked lists again. From scratch 🙃
  #pause
  #admonition(title: "Disclaimer")[
  Original, sensible, conventional linked lists are the one
  actually used.

    But this will come back in Computation Theory.
  ]
]

== Functions as lists
#unistra.slide[
  #v(-1em)
  ```ocaml
let empty = fun f x -> x
let l_1 = fun f x -> f 1 x
let l_1_2 = fun f x -> f 1 @@ f 2 x
let l_1_2_3 = fun f x -> f 1 @@ f 2 @@ f 3 x
  ```
  #v(-0.5em)
  - How to cons ```ocaml 0``` onto ```ocaml l_1_2_3```?
  - How to append ```ocaml l_1_2``` and ```ocaml l_1_2_3```?
]

#unistra.slide[
  #v(-1em)
  ```ocaml
let cons el lst = fun f x -> f el (lst f x)

let append l1 l2 = fun f x -> l1 f (l2 f x)
  ```
  Can we make this simpler?
]

== Interfaces
#unistra.slide[
  #v(-1em)
  #codly(header: [#sym.angle.l;fun_lists.mli#sym.angle.r#sym.eq.triple])
  ```ocaml
type ('el, 'acc) fl =
  ('el -> 'acc -> 'acc) -> 'acc -> 'acc
val empty : ('a, 'b) fl
val cons : 'el -> ('el, 'acc) fl -> ('el, 'acc) fl
val append :
  ('el, 'acc) fl ->
  ('el, 'acc) fl ->
  ('el, 'acc) fl
  ```
]

#unistra.slide[
  #only(1,
  ```ocaml
let cons (el: 'el) (lst: ('el, 'acc) fl) =
  ??? : ('el, 'acc) fl
  ```)
  #only(2,
  ```ocaml
let cons (el: 'el) (lst: ('el, 'acc) fl) =
  ??? : ('el -> 'acc -> 'acc) -> 'acc -> 'acc
  ```)
  #only(3,
  ```ocaml
let cons (el: 'el) (lst: ('el, 'acc) fl) =
  fun (f: 'el -> 'acc -> 'acc) (x: 'acc) ->
    ??? : 'acc
  ```)
]

== Type checking 1
- Currying?
- Introduce Church-encoded lists?
- Use to introduce module interface files?
- Use types to tame them?
- From a type-annotation point
```ocaml
type ('el, 'acc) fl =
  ('el -> 'acc -> 'acc) -> 'acc -> 'acc

let empty : ('el, 'acc) fl = fun f x -> x

let cons (l : 'el) (ls : ('el, 'acc) fl) :
    ('el, 'acc) fl =
 fun f x -> f l (ls f x)

let to_list (ls: ('el, 'acc) fl) : 'el list =
  ls (fun a b -> a::b) []

let append
    (xs:('el, 'acc) fl)
    (ys: ('el, 'acc) fl) :
  ('el, 'acc) fl =
  fun f x -> xs f (ys f x)
```

== Combinatorial functions
- Graph colouring?
#unistra.slide[
  #v(-1em)
  ```ocaml
let rec all_colors colors = function
  | [] -> [[]]
  | v::vertices ->
    List.concat_map (fun color ->
      (List.map
        (fun rest_colors ->
          (v, color)::rest_colors)
        (all_colors colors vertices)))
      colors
  ```
]

- Monadic syntax/custom let?
#unistra.slide[
  #v(-1em)
  ```ocaml
let rec all_colors colors = function
  | [] -> [[]]
  | v::vertices ->
    let ( let* ) x f = List.concat_map f x in
    let ( let+ ) x f = List.map f x in
    let* color = colors in
    let+ rest_colors = all_colors colors vertices in
    (v, color)::rest_colors
  ```
]

#unistra.slide[#v(-1em)
```ocaml
let rec combs = function
  | [] -> [[]]
  | x::xs -> let cs = combs xs in
    List.map (fun xs -> x::xs) cs @ cs
```
]

#unistra.slide[
  #v(-1em)
```ocaml
let rec insert_all el = function
  | [] -> [[el]]
  | x::xs -> (el::x::xs)::
    List.map (fun ys -> x::ys) (insert_all el xs)
let rec perms = function
  | [] -> [[]]
  | x::xs -> let ps = perms xs in
    List.concat_map (insert_all x) ps
```
]

== Type checking 2
- Show how it helps with coding up the combinatorial function
- From an inference point
