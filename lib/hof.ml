(* Plain OCaml lists *)
let empty_ocaml = []
let cons_ocaml el lst = el :: lst

(* Church encoding *)
let empty_church f init = init
let cons_church el lst f init = f el (lst f init)

(* Helper function to convert from plain lists *)
let church_of_list lst = List.fold_right cons_church lst empty_church
let list_of_church lst = lst cons_ocaml empty_ocaml

(* TODO: Implement this *)
let map_church f lst = failwith "TO DO"

(* Scott encoding *)
let empty_scott ifCons ifEmpty = ifEmpty
let cons_scott el lst ifCons ifEmpty = ifCons el lst

(* TODO: Try to implement this -- should be the same as for church_of_list but
   it won't type -- plot hook for next talk *)
let scott_of_list lst = failwith "TO TRY"
