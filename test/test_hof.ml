open Hof

let list123 = church_of_list [1;2;3]
let plus10 = map_church ((+) 10) list123
let _ = assert (list_of_church plus10 = [11;12;13])
