open Mergesort

let test_mergesort () =
  let len = List.length in
  let l = [ 1; 2; 3; 4; 5 ] in
  for m = 0 to len l do
    let lh = take (m, l) in
    let rh = drop (m, l) in
    assert (List.length lh = m);
    assert (List.length rh = len l - m);
    assert (lh @ rh = l)
  done

let _ = test_mergesort ()
