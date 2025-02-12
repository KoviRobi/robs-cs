let len = List.length
let take (_n, _list) = failwith "Not implemented"
let drop (_n, _list) = failwith "Not implemented"

let rec merge = function
  | x :: xs', (y :: _ as ys) when x < y -> x :: merge (xs', ys)
  | xs, y :: ys' -> y :: merge (xs, ys')
  | lst, [] -> lst

let rec sort = function
  | ([] | [ _ ]) as l -> l
  | l ->
      let mid = len l / 2 in
      let lh = take (mid, l) in
      let rh = drop (mid, l) in
      merge (sort lh, sort rh)
