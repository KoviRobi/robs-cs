#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 5],
  subtitle: [Trees: They Are Us. Treeeeeeeeees],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

= Trees
You've been outside. You know what a tree looks like:
#pause
#v(-0.5em)
```ocaml
type 'a tree = Lf
             | Br of 'a * 'a tree * 'a tree
  ```
#pause
#components.side-by-side(columns: (3fr, 2fr))[
  #v(-0.5em)
  #local(display-icon: false, display-name: false, offset: 2)[
    ```ocaml
Br(0, Br(1, Br(3, Lf, Lf),
            Br(4, Lf, Lf)),
      Br(2, Br(5, Lf, Lf),
            Br(6, Lf, Lf)))
    ```
  ]
][
#align(center,
    v(-0.5em) +
    diagram(
      spacing: (0.2em, 0.8em),
      node-stroke: 1pt + black,
      node(( 0, 0), "0", name: <t0_0>),
      edge(<t0_0>, <t0_1>, "->"),
        node((-4, 1), "1", name: <t0_1>),
        edge(<t0_1>, <t0_3>, "->"),
          node((-6, 2), "3", name: <t0_3>),
        edge(<t0_1>, <t0_4>, "->"),
          node((-2, 2), "4", name: <t0_4>),
      edge(<t0_0>, <t0_2>, "->"),
        node(( 4, 1), "2", name: <t0_2>),
        edge(<t0_2>, <t0_5>, "->"),
          node(( 2, 2), "5", name: <t0_5>),
        edge(<t0_2>, <t0_6>,"->"),
          node(( 6, 2), "6", name: <t0_6>),
    ))
  #note[
    Not illustrating leaves and keeping branches short for brevity.
  ]
]

== Infix/prefix/postfix

== Search trees

== Balance

== Red-black tree
- From SV2 material
- Coding exercise?
== Modules/Functors?
- Making a dictionary/set, custom comparator
