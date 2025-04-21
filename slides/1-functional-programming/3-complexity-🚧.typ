#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 3],
  subtitle: [Getting Complex],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

= Why
- Complexity is about scaling
  #pause
  - Rewriting Python in C++ won't help
#pause
- Denial of service
#pause
- Sometimes have to use imperfect solution

= When not
- For small data
  #pause
  - Simple, naïve algorithms can perform better
  #pause
  - E.g. linear search for fewer than \~16 elements

= Example 1 -- Regular expressions
#v(-1em)
#only(1)[
```python
import re
re.match("a?a",          "a")
re.match("a?a?aa",       "aa")
re.match("a?a?a?aaa",    "aaa")
re.match("a?a?a?a?aaaa", "aaaa")
```
]
#only("2-")[
  ```python
import re, time
start = time.process_time()
n = 27
re.match("a?"*n + "a"*n, "a"*n)
print(time.process_time() - start)
  ```
]
#only("3-")[
We will come back to regular expressions later in the course
]
#note[
- Show example
- What do you expect for `n = 28`?
- `grep`
]

= Example 2 -- Deduplicating items
#components.side-by-side(columns: (2fr, 1fr))[
  #v(-1em)
  #only("1-6")[
    #local(display-name: false, display-icon: false)[
      ```python
l = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
for i in range(len(l)):
    for j in range(i + 1, len(l)):
        if l[i] == l[j]:
            break
    else:
        print(l[i])
      ```
    ]
  ]
][
  #only(2)[
    #text(size: 14pt)[
    #stack(dir: ltr,
        $
          & i=0  quad && j= & 1,2,3,4,5,6,7,8,9,10 \
          & i=1  quad && j= & 2,3,4,5,6,7,8,9,10 \
          & i=2  quad && j= & 3,4,5,6,7,8,9,10 \
          & i=3  quad && j= & 4,5,6,7,8,9,10 \
          & i=4  quad && j= & 5,6,7,8,9,10 \
          & i=5  quad && j= & 6,7,8,9,10 \
          & i=6  quad && j= & 7,8,9,10 \
          & i=7  quad && j= & 8,9,10 \
          & i=8  quad && j= & 9,10 \
          & i=9  quad && j= & 10 \
          & i=10 quad && j= &  \
        $,
        context h(measure($lr(} #v(16.7em))"len"(l)$).width)
      )
    ]
  ]
  #only(3)[
    #text(size: 14pt)[
      #stack(
        dir: ltr,
        $
          & i=0  quad && j= 1,2,3,4,5,6,7,8,9,10 \
          & i=1  quad && j= text(fill: #gray, #[$1,$]) 2,3,4,5,6,7,8,9,10 \
          & i=2  quad && j= text(fill: #gray, #[$1,2,$]) 3,4,5,6,7,8,9,10 \
          & i=3  quad && j= text(fill: #gray, #[$1,2,3,$]) 4,5,6,7,8,9,10 \
          & i=4  quad && j= text(fill: #gray, #[$1,2,3,4,$]) 5,6,7,8,9,10 \
          & i=5  quad && j= text(fill: #gray, #[$1,2,3,4,5,$]) 6,7,8,9,10 \
          & i=6  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,$]) 7,8,9,10 \
          & i=7  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,$]) 8,9,10 \
          & i=8  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,8,$]) 9,10 \
          & i=9  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,8,9,$]) 10 \
          & i=10 quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,8,9,10$])  \
        $,
        context h(measure($lr(} #v(16.7em))"len"(l)$).width)
      )
    ]
  ]
  #only("4-6")[
    #text(size: 14pt)[
      #stack(
        dir: ltr,
        $
          #v(-2.1em) \
          & i=0  quad && j= overbrace(#[$1,2,3,4,5,6,7,8,9,10$], "len"(l)) \
          & i=1  quad && j= text(fill: #gray, #[$1,$]) 2,3,4,5,6,7,8,9,10 \
          & i=2  quad && j= text(fill: #gray, #[$1,2,$]) 3,4,5,6,7,8,9,10 \
          & i=3  quad && j= text(fill: #gray, #[$1,2,3,$]) 4,5,6,7,8,9,10 \
          & i=4  quad && j= text(fill: #gray, #[$1,2,3,4,$]) 5,6,7,8,9,10 \
          & i=5  quad && j= text(fill: #gray, #[$1,2,3,4,5,$]) 6,7,8,9,10 \
          & i=6  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,$]) 7,8,9,10 \
          & i=7  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,$]) 8,9,10 \
          & i=8  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,8,$]) 9,10 \
          & i=9  quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,8,9,$]) 10 \
          & i=10 quad && j= text(fill: #gray, #[$1,2,3,4,5,6,7,8,9,10$])  \
        $,
        $lr(} #v(16.7em))"len"(l)$
      )
    ]
  ]
]
#only(5)[#v(-0.5em)$O(n^2/2)$ time complexity#h(1fr)$O(1)$ extra space complexity]
#only(6)[#v(-0.5em)$O(n^2)$ time complexity#h(1fr)$O(1)$ extra space complexity]
#only((7,8))[
  #v(-2.2em)
  ```python
l = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
l.sort()
prev = None
for cursor in range(len(l)):
    if l[cursor] == prev:
        continue
    print(l[cursor])
    prev = l[cursor]
  ```
  #v(-0.5em)
]
#only(8)[$O(n log(n))$ time complexity#h(1fr)$O(1)$ extra space complexity]

#slide[
  - $O(n)$ bags of potatoes? #text(font: "Noto Color Emoji")[🥔👜]
    #pause
    - Complexity measured in input size
      #pause
      - Bytes
    #pause
    - $O(n)$ is an upper bound
      #pause
      - Can ignore all but largest factor
    #pause
    - Specify extra space vs total space
]

= Calculating Complexity
#slide[
    - Replace known functions with cost
  #only("1-5")[- Time complexity:]
  #only(1)[
    #v(-0.5em)
    ```ocaml
let rec merge (xs, ys) = match xs, ys with
  | x::xs', y::ys' when x<y -> x :: merge (xs', ys)
  | x::xs', y::ys'          -> y :: merge (xs, ys')
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(2)[
    #v(-0.5em)
    ```ml
let rec merge (xl, yl) = match xl, yl with
  | xl>0 && yl>0            -> 1 + merge (xl-1, yl)
  | xl>0 && yl>0            -> 1 + merge (xl, yl-1)
  | xl=0 || yl=0      -> 1
    ```
    #v(-0.5em)
  ]
  #only(3)[
    #v(-0.5em)
    ```ml
let rec merge (xl, yl) = match xl, yl with
  | xl>1 && yl>0       -> 1 + (1 + merge (xl-2, yl))
  | xl>0 && yl>1       -> 1 + (1 + merge (xl, yl-2))
  | xl>0 && yl>0       -> 1 + (1 + merge (xl-1, yl-1))
  | xl=0 || yl=0      -> 1
    ```
    #v(-0.5em)
  ]
  #only((4,5))[
    #v(-0.5em)
    ```ml
let rec merge (xl, yl) = xl + yl
    ```
    #v(-0.5em)
  ]
  #only(5)[- $O(m + n)$ time]
  #only("6-9")[- Space complexity:]
  #only(6)[
    #v(-0.5em)
    ```ocaml
let rec merge (xs, ys) = match xs, ys with
  | x::xs', y::ys' when x<y -> x :: merge (xs', ys)
  | x::xs', y::ys'          -> y :: merge (xs, ys')
  | lst, [] | [], lst -> lst
    ```
  ]
  #only(7)[
    #v(-0.5em)
    ```ml
let rec merge (xs, ys) = match xs, ys with
  | xl>0 && yl>0            -> 1 + merge (xl-1, yl)
  | xl>0 && yl>0            -> 1 + merge (xl, yl-1)
  | xl=0 || yl=0      -> 0
    ```
    #v(-0.5em)
  ]
  #only((8,9))[
    #v(-0.5em)
    ```ml
let rec merge xl yl = xl + yl
    ```
    #v(-0.5em)
  ]
  #only(9)[- $O(m + n)$ extra space]
]

#slide[
  - Can you calculate the complexity for ```ocaml take```/```ocaml drop```?
    #pause
    - My ```ocaml take``` is $O(n)$ time and extra space
    - My ```ocaml drop``` is $O(n)$ time and $O(1)$ extra space
      #pause
      - As ```ocaml take``` copies, ```ocaml drop``` does not
]

#slide[
  #v(-1em)
  #only(1)[
    ```ocaml
let rec sort = function
  | ([] | [ _ ]) as l -> l
  | l ->
      let mid = (len l) / 2 in
      let lh = take (mid, l) in
      let rh = drop (mid, l) in
      merge (sort lh, sort rh)
    ```
  ]
  #only(2)[
    ```ml
let rec sort len =
  | len = 0 or 1      -> l
  | len ->
      len +
      len/2 +
      len/2 +
      sort(len/2) + sort(len/2)
    ```
  ]
  #only(3)[
    ```ml
let rec sort len =
  | len = 0 or 1      -> l
  | len ->
      2 * len +
      2 * sort(len/2)
    ```
    #v(-0.5em)
    Simplifies to the equations
    #v(1fr)
    $
    T(0) &= 1 "and" T(1) = 1 \
    T(n) &= 2n + 2T(n\/2)
    $
    #v(0.8em)
  ]
  #only(4)[
    ```ml
let rec sort len =
  | len=0 || len=1       -> 1
  | len ->
      2 * len +
      2 * (2 * len/2 + 2 * sort(len/4))
    ```
    #v(-0.5em)
    Or
    #v(1fr)
    $
    T(n) &= 2n + 2(2n\/2 + 2T(n\/4))
    $
    #v(0.8em)
  ]
  #only(5)[
    ```ml
let rec sort len =
  | len=0 || len=1       -> 1
  | len ->
      4 * len +
      4 * sort(len/4)
    ```
    #v(-0.5em)
    Repeated expansion until list length is zero or one, so $log_2("len")$
    expansions.
    #v(-0.5em)
    #v(1fr)
    $
    T(n) &= 4n + 4T(n\/4)
    $
    #v(0.8em)
  ]
  #only(6)[
    ```ml
let rec sort len = 2 * len * log_2(len)
    ```

  ]
]

= Graphical version
#let gap = h(4em)
#h(1fr) $T(n) = 2 T(n) + 2n$ #h(1fr) and #h(1fr) $T(0 "or" 1) = 1$ #h(1fr)
#fletcher-diagram(
  spacing: (0.3em, 2em),
  node-outset: 0.5em,
  node((0, 0), $2n$, name: <top>),
  node((4, 0), $#gap space.third=2n$),
  pause,
    node((-2, 1), $(2n)/2$, name: <l>),
    node(( 0, 1), $+$),
    node(( 2, 1), $(2n)/2$, name: <r>),
    node(( 4, 1), $#gap+#h(-3pt)=2n$),
    edge(<top>, <l>),
    edge(<top>, <r>),
    pause,
      node((-3, 2), $(2n)/4$, name: <ll>),
      node((-2, 2), $+$),
      node((-1, 2), $(2n)/4$, name: <lr>),
      node(( 0, 2), $+$),
      node(( 2, 2), $+$),
      node(( 1, 2), $(2n)/4$, name: <rl>),
      node(( 2, 2), $+$),
      node(( 3, 2), $(2n)/4$, name: <rr>),
      edge(<l>, <ll>),
      edge(<l>, <lr>),
      edge(<r>, <rl>),
      edge(<r>, <rr>),
      node(( 4, 2), $#gap+#h(-0.1em)=2n$),
      pause,
        node((0, 3), $dots.v$),
        node((4, 3), $dots.v$),
)

= Exercise
#slide[
What does the equation
$
T(1) = 1 \
T(n) = T((3n)/4) + T(n/8) + n
$
reduce to?

[Hint: Easier graphically]
]

= Answer
#slide[
#let gap = h(0em)
#h(1fr) $T(n) = T((3n)/4) + T(n/8) + n$ #h(1fr) and #h(1fr) $T(1) = 1$ #h(1fr)
#fletcher-diagram(
  spacing: (-0.0em, 2em),
  node-outset: 0.5em,
  node((0, 0), $n$, name: <top>),
  node((8, 0), $#gap space.third=n$),
  pause,
    node((-4, 1), $(3n)/4$, name: <l>),
    node(( 0, 1), $+$),
    node(( 4, 1), $n/8$, name: <r>),
    edge(<top>, <l>),
    edge(<top>, <r>),
    pause,
    node(( 8, 1), $#gap +#h(-3pt)=(7n)/8$),
    pause,
      node((-6, 2), $(9n)/16$, name: <ll>),
      node((-4, 2), $+$),
      node((-2, 2), $(3n)/32$, name: <lr>),
      node(( 0, 2), $+$),
      node(( 2, 2), $(3n)/32$, name: <rl>),
      node(( 4, 2), $+$),
      node(( 6, 2), $n/64$, name: <rr>),
      edge(<l>, <ll>),
      edge(<l>, <lr>),
      edge(<r>, <rl>),
      edge(<r>, <rr>),
      pause,
      node(( 8, 2), $#gap +#h(-0.1em)=(49n)/64$),
      pause,
        node((-7, 3), $(27n)/64$, name: <lll>),
        node((-6, 3), $+$),
        node((-5, 3), $(9n)/128$, name: <llr>),
        node((-4, 3), $+$),
        node((-3, 3), $(9n)/128$, name: <lrl>),
        node((-2, 3), $+$),
        node((-1, 3), $(3n)/256$, name: <lrr>),
        node(( 0, 3), $+$),
        node(( 1, 3), $(9n)/128$, name: <rll>),
        node(( 2, 3), $+$),
        node(( 3, 3), $(3n)/256$, name: <rlr>),
        node(( 4, 3), $+$),
        node(( 5, 3), $(3n)/256$, name: <rrl>),
        node(( 6, 3), $+$),
        node(( 7, 3), $n/512$, name: <rrr>),
        edge(<ll>, <lll>),
        edge(<ll>, <llr>),
        edge(<lr>, <lrl>),
        edge(<lr>, <lrr>),
        edge(<rl>, <rll>),
        edge(<rl>, <rlr>),
        edge(<rr>, <rrl>),
        edge(<rr>, <rrr>),
        pause,
        node(( 8, 3), $#gap +#h(-0.1em)=(#(49*7) n)/#(64*8)$),
)
]
#slide[
  Geometric sum $n + (7n)/8 + (49n)/64 + (343n)/512 + dots.c.h$
  #v(-0.5em)
  $
  "Let" S_i =& a x^0 + a x^1 + dots.c.h + a x^i \
  => S_i (1-x) =& a x^0 + a x^1 - a x^1 + dots.c.h + a x^i - a x^i - a x^(i+1) \
  => S_i = a (1 - x^(i+1))/(1-x)
  $
  #v(-0.5em)
  So
  #v(-1em)
  $
  a = n; #h(1em) x=7/8
  $
]
#slide[
  Expanding at most $n * (3/4)^i = 1$ iterations. Solved for $i$:
  $
  i= log(1\/n)/log(3\/4) = log(n)/log(4\/3) = c log(n) "where" c = 1/log(4\/3)
  $
  So
  $
  S_i
  = a (1-x^(i+1))/(1-x)
  = n((1-(7/8)^(c log(n))/(1-7/8))
  = 8n(1-(7/8)^(c log(n)))
  < 8n
  $
]
