#import "@preview/touying:0.5.3": *
#import "unistra/unistra.typ": *
#import "unistra/colors.typ": *
#import "unistra/admonition.typ": *

#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Rob's CS],
    subtitle: [_Functional Programming_],
    author: [Robert Kovacsics],
    date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
    logo: image(width: 80%, "branding/carallon/carallon_logo_white.png"),
  ),
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide(logo: image("branding/carallon/carallon_logo_white.png"))

= OCaml
Why?

Because I know it.

Simple syntax.

This knowledge is applicable to other languages.

== Syntax overview
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
