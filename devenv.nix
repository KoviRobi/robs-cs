{
  pkgs,
  ...
}:

{
  cachix.enable = false;

  # https://devenv.sh/packages/
  packages =
    [
      pkgs.git
      pkgs.typst
      pkgs.pdfpc
      pkgs.polylux2pdfpc
    ]
    ++ (builtins.attrValues {
      inherit (pkgs.ocamlPackages)
        ocaml
        utop
        ocaml-lsp
        odoc
        ocamlformat
        ocamlformat-rpc-lib
        ;
    });

  # https://devenv.sh/scripts/
  scripts.build.exec = ''
    typst compile slides.typ
    polylux2pdfpc slides.typ
  '';
  scripts.present.exec = ''
    [ slides.typ -ot slides.pdf ] || build
    pdfpc slides.pdf
  '';
}
