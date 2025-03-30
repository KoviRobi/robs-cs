#import "../../preamble.typ": *

#show: init(
  title: [Rob's CS Appendix A],
  subtitle: [_`git` gud_],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

#let folder = text(font: "Noto Sans Symbols")[🗀]
#hero(
  grid(align: left + horizon, columns: 4, rows: 1fr,
    align(center + horizon,
      diagram(
        node((0, 0),       box(circle(radius: 6pt))), node((0.5, 0),   [v2.0]),
        edge((0, 0), (0.3, 0.4), "->"),
        node((0.3, 0.4),   circle(radius: 6pt)),
        edge((0.3, 0.4), (0, 0.8), "->"),
        edge((0, 0), (0, 0.8), "->"),
        node((0, 0.8),     box(circle(radius: 6pt))), node((0.5, 0.8), [v1.1]),
        edge((0, 0.8), (0, 1.4), "->"),
        node((0, 1.4),     box(circle(radius: 6pt))), node((0.5, 1.4), [v1.0]),
      )
    ),
    image(fit: "stretch", height: 100%, width: 100%, "big-brain-1.jpg")+pause,
    image(fit: "stretch", height: 100%, width: 100%, "big-brain-2.jpg"),
    box(inset: 0.5em,
      terms(spacing: 0em,
        terms.item(folder)[v1.0],
        terms.item(folder)[v1.1],
        terms.item(folder)[v2.0],
      ),
    )+pause,
    box(inset: 0.5em,
      terms(spacing: 0em,
        terms.item(folder)[final],
        terms.item(folder)[final-fixed],
        terms.item(folder)[final-for-real],
        terms.item(folder)[final-final],
      ),
    ),
    image(fit: "stretch", height: 100%, width: 100%, "big-brain-3.jpg")+pause,
    image(fit: "stretch", height: 100%, width: 100%, "big-brain-4.jpg"),
    box(inset: 0.5em,
      terms(spacing: 0em,
        terms.item(folder)[final],
        terms.item(folder)[finall],
        terms.item(folder)[aaaaaa #h(1em)],
        terms.item(folder)[lkjfsd],
      ),
    ),
  ),
)
