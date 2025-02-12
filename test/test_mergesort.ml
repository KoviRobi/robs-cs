open Mergesort

let test_mergesort () =
  let n = Random.int_in_range ~min:10 ~max:100 in
  let l = List.init n (fun _ -> Random.int 1000) in
  for m = 0 to n do
    let lh = take (m, l) in
    let rh = drop (m, l) in
    assert (List.length lh = m);
    assert (List.length rh = n - m);
    assert (lh @ rh = l)
  done

let _ = test_mergesort ()
