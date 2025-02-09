#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.3": *

#show: codly-init.with()
#codly(
  languages: codly-languages,
  number-format: none,
)

= OCaml install

I recommend you do this before the talk, so that you can participate in the
practical portion. The steps are short to type, just the computer takes a long
time over the installation.

The following commands are typed in a normal Windows terminal (either
PowerShell or cmd should be fine, no need to be administrator).
+ Installing OCaml
  + Install opam by running
    ```powershell
winget install OCaml.opam
    ```
    #codly(display-icon: false, display-name: false)

  + Restart terminal (for PATH changes to take effect), set up the default OCaml
    environment. The defaults should be fine (default number underlined).
    ```powershell
opam init
    ```

  + Install some useful developer tools
    ```powershell
opam install ocaml-lsp-server odoc ocamlformat utop
    ```

+ Installing VS Code
  + Install VS Code, if you haven't already got it (you can instead use your own
    favourite text editor, if you prefer, as long as it supports the
    language-server protocol it should work).
    ```powershell
winget install Microsoft.VisualStudioCode
    ```

  + Install the VS Code extension
    ```powershell
code --install-extension ocamllabs.ocaml-platform
    ```

= Check everything is working

Now you should be able to select the default OCaml environment. You are okay to
close warnings/errors about environment not selected yet -- these appear
because you haven't opened VS Code from a shell which has had
```sh eval "$(opam switch)"``` called, but this is okay.

See @_1-ocaml-sandbox-select for how to select the environment, you should then
get a screen as in @_2-ocaml-sandbox-selected. Some suggested settings are
shown in @_3-workspace-settings, though these aren't necessary.

I use a font with coding ligatures, e.g. CaskaydiaCove. You can get these from
#underline(link("https://www.nerdfonts.com/font-downloads")), the following
have ligatures: CaskaydiaCove, D2CodingLigature, FantasqueSansM, FiraCode,
GeistMono, Hasklug, Iosevka, IosevkaTerm, IosevkaTermSlab, JetBrainsMono,
Lilex, Monoid, VictorMono, ZedMono.

During coding, if you want to send some text to the interpreter, you can select
the text and press "Shift+Enter", see @_4-eval-selection. Other than that,
hover documentation (@_5-doc-hover) and autocompletion (@_6-tab-completion) is
available as usual.

Note, the interpreter require double semicolons to know we have stopped
editing. Helpful interpreter commands:
/ `#help;;`: shows more
/ `#use "file.ml";;`: to load a file
/ `#show thing;;`: to show type, or module contents

#figure(
  caption: [Selecting the OCaml environment] + align(left)[
    + Select the OCaml pane/tab.
    + Click select sandbox
    + Select the "default" sandbox
      (the global, inherited from the environment isn't useful because VS Code.
      wasn't launched from a terminal with ```sh eval "$(opam switch)"``` having
      set the environment)
    #v(2em)
  ],
  image("images/vs-code/1-ocaml-sandbox-select.png"),
) <_1-ocaml-sandbox-select>

#figure(
  caption: [Selected OCaml environment. #v(2em)],
  image("images/vs-code/2-ocaml-sandbox-selected.png"),
) <_2-ocaml-sandbox-selected>

#figure(
  caption: [Suggested settings. #align(left)[
    Note: you need to create a `.ocamlformat` file for the autoformatter, an
    empty file works.]
    #v(2em)],
  image("images/vs-code/3-workspace-settings.png"),
) <_3-workspace-settings>

#figure(
  caption: [Use Shift+Enter to send selected text to the interpreter #v(2em)],
  image("images/vs-code/4-eval-selection.png"),
) <_4-eval-selection>
#figure(
  caption: [Hover documentation for ```ocaml String.concat```, with its type
  at the top. #v(2em)],
  image("images/vs-code/5-doc-hover.png"),
) <_5-doc-hover>
#figure(
  caption: [Auto-completion, as usual #v(2em)],
  image("images/vs-code/6-tab-completion.png"),
) <_6-tab-completion>

/*
== TODO?
- `utop -require ppx_deriving.show`?
- Fmt?
*/
