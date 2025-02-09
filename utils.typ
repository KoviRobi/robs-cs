#import "@preview/touying:0.5.3": *
#import "@preview/codly:1.2.0": *

/**
Reveals code bit-by-bit. Pauses is an array of line numbers, start is the start
number.
*/
#let codly-reveal(pauses, content, start: 1) = {
  for (slide, end) in pauses.enumerate(start: start) {
    only(slide)[
      #codly-range(0, end: end)
      #content
    ]
  }
}

/** Helper for `sublist`, matching on content and array */
#let sublist_content(sublist_array, body, n) = {
  if type(body) == array {
    sublist_array(body, n)
  } else if type(body) == content {
    let func = body.func()
    if repr(func) == "item" {
      if n <= 0 {
        ([], n)
      } else {
        let (body, n) = sublist_content(sublist_array, body.body, n - 1)
        (func(body), n)
      }
    } else if repr(func) == "sequence" {
      let (children, n) = sublist_content(sublist_array, body.children, n)
      (func(children), n)
    } else {
      (body, n)
    }
  } else {
    (body, n)
  }
}

/** Helper for `sublist`, matching only on array */
#let sublist_array(array, n) = {
  if array.len() == 0 {
    ((), n)
  } else {
    let (first, ..rest) = array
    let (first, n) = sublist_content(sublist_array, first, n)
    let (rest, n) = sublist_array(rest, n)
    ((first, ..rest), n)
  }
}

/**
Reveal only `n` elements of the list (counting nested elements separately)
 */
#let sublist(n, body) = {
  let (sub, _) = sublist_content(sublist_array, body, n)
  sub
}
