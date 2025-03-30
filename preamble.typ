#import "@preview/touying:0.6.1" as touying: *
#import "unistra/unistra.typ" as unistra: *
#import "unistra/colors.typ": *
#import "unistra/admonition.typ": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "@preview/fletcher:0.5.7" as fletcher: *

#import "utils.typ": *

// '<,'>!ocamlformat - --impl

#let slide = unistra.slide

#let note(str) = [
  #speaker-note(str)
  #pdfpc.speaker-note(raw(repr(str)))
]

#let init(title: none, subtitle: none) = body =>{
  assert(title != none, message: "Title missing")
  assert(subtitle != none, message: "Subtitle missing")
  return codly-init(
    unistra-theme(
      aspect-ratio: "16-9",
      config-info(
        title: title,
        subtitle: subtitle,
        author: [Robert Kovacsics],
        date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
        logo: image(width: 80%, "branding/carallon/carallon_logo_black.png"),
      ),
      config-common(
        // show-notes-on-second-screen: right,
        preamble: {
        codly(
          languages: codly-languages + (
            ml: (
              name: "PseudOCaml",
              color: rgb("#484444"),
            ),
          ),
          zebra-fill: luma(251),
          lang-fill: (lang) => lang.color.lighten(95%),
          highlight-inset: 0pt,
          highlight-outset: 0.32em,
          highlight-clip: false,
          highlight-stroke: color => 0pt,
        )
      }
      ),
      body
    )
  )
}

#let slide = unistra.slide
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#let title-slide = unistra.title-slide(logo: image(height: 95%, "branding/carallon/carallon_logo_white.png"))
