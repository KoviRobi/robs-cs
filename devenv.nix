{
  self,
  inputs,
  pkgs,
  ...
}:
let
  typst-env = builtins.attrValues {
    inherit (pkgs)
      polylux2pdfpc
      typst
      ;
  };
in
{
  cachix.enable = false;

  outputs = {
    typst-packages =
      let
        inherit (builtins)
          attrNames
          elemAt
          filter
          map
          match
          ;
        names = attrNames inputs;
        codly-languages = elemAt (filter (n: match ".*/codly-languages:.*" n != null) names) 0;
        inputs' = inputs // {
          ${codly-languages} = "${inputs.${codly-languages}}/codly-languages";
        };
        typst-names = filter (x: x != null) (map (n: match "(typst/([^/]*/[^:]*):(.*))" n) names);
      in
      pkgs.linkFarm "typst-packages" (
        map (name-path-ver: {
          name = "${elemAt name-path-ver 1}/${elemAt name-path-ver 2}";
          path = inputs'.${elemAt name-path-ver 0};
        }) typst-names
      );

    docker-typst = pkgs.dockerTools.streamLayeredImage {
      name = "ghcr.io/KoviRobi/robs-cs-typst";
      tag = "latest";
      contents = typst-env ++ [
        pkgs.coreutils
        pkgs.dockerTools.binSh
        pkgs.dockerTools.usrBinEnv
        pkgs.dockerTools.caCertificates
        pkgs.stdenv.cc.libc.bin
        (pkgs.writeTextDir "/etc/os-release" ''
          DEFAULT_HOSTNAME=nixos
          HOME_URL="https://nixos.org/"
          ID=nixos
          NAME=NixOS
          SUPPORT_URL="https://nixos.org/community.html"
        '')
        pkgs.gnutar
        pkgs.gzip
        # Github runs its own Node JS for the actions, which we cannot patch so
        # we use the nix-ld dynamic linker as the docker OS dynamic linker, see
        # NIX_LD and NIX_LD_LIBRARY_PATH below
        (pkgs.runCommand "nix-ld-linker" { } ''
          ldpath="$(cat ${pkgs.nix-ld}/nix-support/ldpath)"
          mkdir -p "$out/$(dirname "$ldpath")"
          ln -s ${pkgs.nix-ld}/libexec/nix-ld "$out/$ldpath"
        '')
      ];
      config = {
        Env = [
          "TYPST_PACKAGE_PATH=${self.devenv.outputs.typst-packages}"
          "TYPST_FONT_PATHS=${pkgs.nerd-fonts.caskaydia-cove}/share/fonts/truetype/NerdFonts/CaskaydiaCove"
          "NIX_LD=${pkgs.stdenv.cc.bintools.dynamicLinker}"
          "NIX_LD_LIBRARY_PATH=${
            pkgs.lib.makeLibraryPath [
              pkgs.zlib
              pkgs.zstd
              pkgs.stdenv.cc.cc
              pkgs.curl
              pkgs.openssl
              pkgs.attr
              pkgs.libssh
              pkgs.bzip2
              pkgs.libxml2
              pkgs.acl
              pkgs.libsodium
              pkgs.util-linux
              pkgs.xz
            ]
          }"
        ];
      };
    };
  };

  # https://devenv.sh/packages/
  packages =
    typst-env
    ++ [
      pkgs.git
      pkgs.pdfpc
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

  env = {
    TYPST_PACKAGE_PATH = self.devenv.outputs.typst-packages;
    TYPST_FONT_PATHS = "${pkgs.nerd-fonts.caskaydia-cove}/share/fonts/truetype/NerdFonts/CaskaydiaCove";
  };

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
