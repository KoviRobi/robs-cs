#import "../../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 8],
  subtitle: [Modules],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide()

= Sets of what?
We used ```ocaml =```, ```ocaml <``` and ```ocaml >``` but how are they
defined?

/ C++: Operator overloading
/ Python/Java: Class methods
/ Haskell/Rust: Typeclasses
/ OCaml: Modules and functors

= Module signatures
Similar to C/C++ headers, or interfaces/abstract base classes
#v(-0.5em)
#alternatives[
  ```ocaml
type order = Less | Equal | Greater
module type ORDER = sig
  type t
  val compare : t -> t -> order
end
  ```
][
  ```ocaml
module type SET = sig
  type t
  type set
  val empty : set
  val has : t -> set -> bool
  val insert : t -> set -> set
end
  ```
]

= Modules
Implementation of a module signature
#v(-0.5em)
```ocaml
module IntOrder = struct
  type t = int
  let compare a b =
    if a < b then Less
    else if a = b then Equal
    else Greater
end
```

= Opaque implementation
#alternatives[
  Modules implement signatures implicitly
  #v(-0.5em)
  ```ocaml
module type T = sig
  type token
  val get_token : unit -> token
end
module M1 = struct
  type token = Token of int
  let get_token () = Token 12345
end
  ```
][
  Can name explicitly, hides implementation
  #v(-0.5em)
  ```ocaml
module type T = sig
  type token
  val get_token : unit -> token
end
module M2 : T = struct
  type token = Token of int
  let get_token () = Token(12345)
end
  ```
]

= Functors
Parametrize modules by types
#v(-0.5em)
#codly(display-icon: false, display-name: false)
```ocaml
module Set(O: ORDER): SET with type t = O.t = struct
  type t = O.t
  type set = Lf | Br of t * set * set
  let empty = Lf

  let rec has el = function Lf -> false | Br(v,l,r) ->
    match O.compare el v with Equal -> true
    | Less -> has el l | Greater -> has el r

  let rec insert el = function Lf -> Br(el,Lf,Lf)
    | Br(v, l, r) as t -> match O.compare el v with
      | Equal -> t
      | Less -> Br(v, insert el l, r)
      | Greater -> Br(v, l, insert el r)
end
```

= Usage
#v(-1em)
```ocaml
module IntSet = Set(IntOrder)
let s = IntSet.insert 1 (IntSet.insert 2 IntSet.empty)
let true = IntSet.has 1 s
let false = IntSet.has 3 s
```

= Map type
For maps, we want to have a polymorphic value
#v(-0.5em)
```ocaml
module Map(O: ORDER) = struct
  type t = O.t
  type +!'a map = Lf | Br of t * 'a * 'a map * 'a map
  let empty = Lf
  let rec insert k v = function Lf -> Br(k, v, Lf, Lf)
  | Br(k', v', l, r) -> match O.compare k k' with
    | Equal -> Br(k', v, l, r)
    | Less -> Br(k', v', insert k v l, r)
    | Greater -> Br(k', v', l, insert k v r)
end
```
