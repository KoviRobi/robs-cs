#import "../../preamble.typ": *
#import fletcher.shapes: pill, house

#let tag = house.with(angle: 45deg, dir: right)

#show: init(
  title: [Rob's CS Appendix A],
  subtitle: [_`git` gud_],
)

#show raw: set text(size: 19pt)

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

= Git under the hood
- Why
  - Good mental model
#pause
- Doesn't
  - use diffs
#pause
- Does
  - store the full file for each commit
  - compress
  - use a local database

= Database
- Maps hash of object to object value
- Few object types (commit, tree, blob, annotated tag)
- See `.git/objects`

== Test repo
#v(-1em)
#codly-reveal((1,3,7))[
  ```shell
$ mkdir /tmp/test; cd /tmp/test
$ git init
Initialized empty Git repository in /tmp/test/.git/
$ find .git -type f
.git/HEAD                   .git/config
.git/description            .git/hooks/...
.git/info/exclude
  ```
]

== Blobs
- Raw file contents
#v(-0.5em)
#codly-reveal((1,2,4,6,8))[
  ```shell
$ echo 'Hello, world' >README
$ git add README
$ find .git/objects -type f
.git/objects/a5/c19667710254f835085b99726e523457150e03
$ git cat-file -t a5c1
blob
$ git cat-file blob a5c1
Hello, world
  ```
]

== Trees
#only(1)[
  Let's make commits reproducible
  #v(-0.5em)
  ```shell
$ export GIT_CONFIG_GLOBAL=.gitconfig
$ export GIT_{AUTHOR,COMMITTER}_DATE=2025-05-19T14:00
$ cat <<EOF >.gitconfig
[user]
name=Test
email=test@mail.com
EOF
  ```
]
#codly-reveal((1,5,7,9), start: 2)[
  #v(-1em)
  ```shell
$ git commit -m 'Initial commit'
$ find .git/objects -type f
.git/objects/a5/c19667710254f835085b99726e523457150e03
.git/objects/60/85225d73e7636ca5ab1b271392ffb967839a3b
.git/objects/d2/6008e944881b659a5bdaaa755c1794aa9574a8
$ git cat-file -t 6085
tree
$ git ls-tree --abbrev 6085
100644 blob a5c1966     README
  ```
]

== Commits
#v(-1em)
#codly-reveal((2,8))[
  ```shell
$ git cat-file -t d260
commit
$ git cat-file -p d260
tree 6085225d73e7636ca5ab1b271392ffb967839a3b
author Test <test@mail.com> 1747659600 +0100
committer Test <test@mail.com> 1747659600 +0100

Initial commit
  ```
]
#codly-reveal((2,9), start: 3)[
  ```shell
$ echo Bye >>README
$ git commit -am 'Update README'
$ git cat-file -p HEAD
tree a6c87816a666a4131e9fa4b45a5a7f67dcf3e4e1
parent d26008e944881b659a5bdaaa755c1794aa9574a8
author Test <test@mail.com> 1747659600 +0100
committer Test <test@mail.com> 1747659600 +0100

Update README
  ```
]

== Revisions
#slide(repeat: 4, self => {
  let (only, alternatives) = utils.methods(self);
  let alternatives = alternatives.with(stretch: true, position: horizon + center);
  components.side-by-side(columns: (3fr, 2fr))[
    #only("1-", [- `HEAD` or `@`])
    #only("2-", [- `<rev>~[n]`])
    #only("3-", [- `<rev>^[n]`])
    #only("4-", [- `<rev>^{/regexp}` and `:/regexp`])
  ][
    #align(center, diagram(
      node-shape: pill,
      node-stroke: black,
      spacing: 1em,
      node((0, 0), alternatives[`HEAD`][`@`]),
      edge((0, 0), (1, 1), "->"),
      edge((0, 0), (2, 1), "->", bend: 26deg),
      node((1, 1), alternatives[`abc`][`abc`][`@^`#sym.space.thin]),
      node((2, 1), alternatives[`def`][`def`][`@^2`]),
      edge((1, 1), (0, 2), "->"),
      edge((0, 0), (0, 2), "->"),
      node((0, 2), alternatives[`012`][`@~`]),
      edge((0, 2), (0, 4), "->"),
      node((0, 4), alternatives[`345`][`@~2`]),
    ))
  ]
})

= Branches
- Files in `.git/refs/heads/<name>` containing hash to commit object

= Tags -- lightweight
- Files in `.git/refs/tags/<name>` containing hash to commit object
  #v(-0.5em)
  ```shell
$ git tag lightweight
$ git cat-file -t $(.git/refs/tags/lightweight)
commit
  ```
= Tags -- annotated
- Files in `.git/refs/tags/<name>` containing hash to tag object
    #v(-0.5em)
    ```shell
$ git tag -m 'Annotated' annotated
$ git cat-file -t $(.git/refs/tags/annotated)
tag
    ```

= Amend

= Revisions 2
- Asymmetric `<rev1>..``<rev2>` /* Avoid `..<` ligature */
- Symmetric `<rev1>...<rev2>`

= Interactive Rebase
#slide[
  #v(-1em)
  #fletcher-diagram(
    spacing: (1.5em, 3em),
    node-shape: pill,
    node-stroke: black,
    node((-1, 0), `branch`, shape: tag),
    edge("->"),
    node((0, 0), `89ab`),
    edge("->"),
    node((0, 1), `4567`),
    edge("->"),
    node((0, 2), `0123`),
    edge("<-"),
    node((-1, 2), `branch@{u}`, shape: tag),
    pause,
    node((1, 1), `0246`),
    edge((0, 2), "->"),
    pause,
    node((1, 0), `8ace`),
    edge((1, 1), "->"),
  )
][
  #meanwhile
  #for (s, hi) in (
    none,
    ((line: 1),),
    ((line: 2),),
  ).enumerate(start: 1) {
    only(s, local(number-format: none, highlights: hi)[
      #v(-1em)
      ```git-rebase-todo
      pick 4567
      pick 89ab
      #
      # p, pick   <commit>
      # e, edit   <commit>
      # s, squash <commit>
      # f, fixup [-C|-c] <commit>
      # b, break
      ```
    ])
  }
]

= Rebase keep merges

= First-parent

= Range-diff

= Conflicts
