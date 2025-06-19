(* Plain OCaml lists *)
let empty_ocaml = []
let cons_ocaml el lst = el :: lst

(* Church encoding *)
let empty_church f init = init
let cons_church el lst f init = f el (lst f init)

(* Helper function to convert from plain lists *)
let church_of_list lst = List.fold_right cons_church lst empty_church
let list_of_church lst = lst cons_ocaml empty_ocaml

(* We create a new list with `f` applied to each element *)
let map_church f lst = lst (fun el acc -> cons_church (f el) acc) empty_church

(* An alternative implementation is usinf `Fun.compose`

   let map_church f lst = lst (Fun.compose cons_church f) empty_church
*)

(* Scott encoding *)
let empty_scott ifCons ifEmpty = ifEmpty
let cons_scott el lst ifCons ifEmpty = ifCons el lst

(* This runs into a type error -- the reason for this will be discussed in the
   next talk

   let scott_of_list lst = List.fold_right cons_scott lst empty_scott
*)
