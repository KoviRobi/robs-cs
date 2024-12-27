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
    title: [Rob's CS 5],
    subtitle: [Trees: They Are Us. Treeeeeeeeees],
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
