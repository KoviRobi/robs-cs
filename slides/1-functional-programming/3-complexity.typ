#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 3],
  subtitle: [Getting Complex],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

Want this section to be as short as possible. Illustrate first with regexp
example for some practical example?

Sort + uniq?

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
  - E.g. linear search for fewer than ~16 elements

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
#note(```
- Show example
- What do you expect for `n = 28`?
- `grep`]
```)
#pause
#pause
We will come back to regular expressions later in the course

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
l.sorted()
prev = None
for cursor in range(len(l)):
    if (l[cursor],) == prev
        continue
    print(l[cursor])
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
  | xl>0 && yl>0       -> 1 + (1 + merge (xl-2, yl))
  | xl>0 && yl>0       -> 1 + (1 + merge (xl, yl-2))
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
      let mid = len l / 2 in
      let lh = take (mid, l) in
      let rh = drop (mid, l) in
      merge (sort lh, sort rh)
    ```
  ]
  #only(2)[
    ```ml
let rec sort len =
  | len = 0 or 1      -> l
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

- TODO: Visualise as tree
