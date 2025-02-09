#import "../0-preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 5],
  subtitle: [Trees: They Are Us. Treeeeeeeeees],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

= Trees
We all know what a tree looks like
#pause
```ocaml
type 'a tree =
  Lf | Br of 'a * 'a tree * 'a tree
```

== Infix/prefix/postfix

== Search trees
== Balance

== Red-black tree
- From SV2 material
- Coding exercise?
== Modules/Functors?
- Making a dictionary/set, custom comparator
