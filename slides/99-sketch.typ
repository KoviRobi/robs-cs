#import "../preamble.typ": *

// '<,'>!ocamlformat - --impl

#show: init(
  title: [Rob's CS 1],
  subtitle: [_Functional Programming_ 1],
)

#show raw: set text(font: "CaskaydiaCove NF")

#title-slide

== Monadic syntax
== Infix operators, custom let
== Option; monads
== Exceptions

= Outline
```dot
digraph {
  OCaml -> Prolog
  OCaml -> Types
  OCaml -> CompTheory [label="lambda calculus"]
  OCaml -> RegEx
  OCaml -> Memoization
  RegEx -> Memoization [label="for backtracking implementations"]
  RegEx -> CompTheory [label="finite-state automata"]
  RegEx -> Complexity [label="naive backtracking vs automata"]
  OCaml -> Compilers
  OCaml -> Algorithms
  OCaml -> OS [label="MirageOS"]
}
```

= Regex
+ Introduce
+ Mention parsing HTML meme
+ Parsing balanced pairs
  + Example: C++ templates, ellipsisation
    Real worked example

#slide[
  ```
auto Cli<PrintfIo&>::Parser<Cli<PrintfIo&>::Command<1ul>, Cli<PrintfIo&>::Command<1ul, NumArg<unsigned int, 0u, 23u> >, Cli<PrintfIo&>::Command<1ul, ChoiceArg<Status, 2ul> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<FanGroup, 10ul> >, Cli<PrintfIo&>::Command<2ul, NumArg<unsigned char, (unsigned char)0, (unsigned char)100> >, Cli<PrintfIo&>::Command<2ul, ChoiceArg<FanGroup, 10ul>, NumArg<unsigned char, (unsigned char)0, (unsigned char)100> >, Cli<PrintfIo&>::PageBreak, Cli<PrintfIo&>::Command<1ul, ChoiceArg<FanSensors, 29ul> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::Id, 2ul>, NumArg<unsigned short, (unsigned short)0, (unsigned short)65535> >, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::Id, 2ul>, NumArg<unsigned short, (unsigned short)0, (unsigned short)65535>, NumArg<unsigned char, (unsigned char)0, (unsigned char)255> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<2ul, ChoiceArg<ClkSynth::VersionY, 6ul> >, Cli<PrintfIo&>::PageBreak, Cli<PrintfIo&>::Command<2ul, ChoiceArg<IoCards::Card, 4ul>, NumArg<bool, false, true> >, Cli<PrintfIo&>::Command<2ul>, Cli<PrintfIo&>::Command<3ul>, Cli<PrintfIo&>::Command<3ul>, Cli<PrintfIo&>::Command<3ul, StrArg>, Cli<PrintfIo&>::Command<3ul> >::help(PrintfIo&, std::basic_string_view<char, std::char_traits<char> >, bool) const::{lambda<unsigned long... $N0>(std::integer_sequence<unsigned long, ($N0)...>)#1}::operator()<0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul, 13ul, 14ul, 15ul, 16ul, 17ul, 18ul, 19ul, 20ul>(std::integer_sequence<unsigned long, 0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul, 13ul, 14ul, 15ul, 16ul, 17ul, 18ul, 19ul, 20ul>) const
  ```
  Ouch!
]
#slide[
  End result
  ```
auto Cli⟨...⟩::Parser⟦...⟧::help(PrintfIo&, std::basic_string_view⟪...⟫, bool) const::{lambda⟨...⟩(std::integer_sequence⟨...⟩)#1}::operator()⟨...⟩(std::integer_sequence⟨...⟩) const
  ```
  "Readable for C++" -- most people would say ugly, but then you run out of
  terms to describe the original one.
]
#slide[
  ```sh
sed -e 's/\(([^()]*)\)<\(([^()]*)\)/\1⍃\2/g' \
  ```
  Replace comparison less-than, because C++ abuses less-than and greater-than
  symbols as angle brackets.
#pause
  #codly(offset: 1)
  ```sh
    -e 's/\(([^()]*)\)>\(([^()]*)\)/\1⍄\2/g' \
  ```
  Same but for greater-than.
]
#slide[
  Now we can ellipsisise the innermost balanced pair.
  #codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟨...⟩/g' \
  ```
#pause
  Which leaves us with the next balanced pair.
#codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟪...⟫/g' \
  ```
]
#slide[
  And again.
  #codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟦...⟧/g' \
  ```
#pause
  The Ginosaji never gives up.
  #codly(offset: 1)
  ```sh
    -e 's/<\([^<>]*\)>/⟬...⟭/g' |
  ```
]
#slide[
    Repeated removal of innermost parentheses, as regex cannot do balanced
    pairs. Replace with non-parentheses.
    Results in:
    ```
auto Cli⟨...⟩::Parser⟦...⟧::help(PrintfIo&, std::basic_string_view⟪...⟫, bool) const::{lambda⟨...⟩(std::integer_sequence⟨...⟩)#1}::operator()⟨...⟩(std::integer_sequence⟨...⟩) const
    ```
]

    Also most regexes irregular in every sense of the word. Demo the
    exponential PCRE blowup.

= Operating systems?
SystemTap? Look at RNW's DTrace things again

MirageOS?

= Concurrency models
C++11 memory models
