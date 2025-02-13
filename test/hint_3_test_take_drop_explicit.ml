(* Allows us to refer to Mergesort.take/Mergesort.drop with just take/drop *)
open Mergesort

let _ = assert (take (0, 1 :: 2 :: 3 :: []) = [])
let _ = assert (take (1, 1 :: 2 :: 3 :: []) = [ 1 ])
let _ = assert (take (2, 1 :: 2 :: 3 :: []) = [ 1; 2 ])
let _ = assert (take (3, 1 :: 2 :: 3 :: []) = [ 1; 2; 3 ])

let _ = assert (drop (0, 1 :: 2 :: 3 :: []) = [ 1; 2; 3 ])
let _ = assert (drop (1, 1 :: 2 :: 3 :: []) = [ 2; 3 ])
let _ = assert (drop (2, 1 :: 2 :: 3 :: []) = [ 3 ])
let _ = assert (drop (3, 1 :: 2 :: 3 :: []) = [])
