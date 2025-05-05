{
  self,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  ocaml-env = builtins.attrValues {
    inherit (pkgs.ocamlPackages)
      ocaml
      utop
      ocaml-lsp
      odoc
      ocamlformat
      ocamlformat-rpc-lib
      dune_3
      ;
  };

  typst-env = builtins.attrValues {
    inherit (pkgs)
      polylux2pdfpc
      typst
      ;
  };

  pages-env = [
    (pkgs.python3.withPackages (pkgs: [
      pkgs.css-html-js-minify
    ]))
    pkgs.scour
  ];
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
      contents =
        typst-env
        ++ pages-env
        ++ [
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
          "TYPST_PACKAGE_PATH=${self.devenv.env.TYPST_PACKAGE_PATH}"
          "TYPST_FONT_PATHS=${self.devenv.env.TYPST_FONT_PATHS}"
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

    docker-ocaml = pkgs.dockerTools.streamNixShellImage {
      name = "robs-cs-ocaml";
      tag = "latest";
      drv = pkgs.mkShell {
        packages =
          ocaml-env
          # Compatibility for devcontainer
          ++ [
            pkgs.coreutils
            pkgs.dockerTools.binSh
            pkgs.dockerTools.usrBinEnv
            pkgs.dockerTools.caCertificates

            # VSCode devenv tools
            # VSCode reads /etc/os-release to find stuff out about the
            # container, so put something there
            (pkgs.writeTextDir "/etc/os-release" ''
              DEFAULT_HOSTNAME=nixos
              HOME_URL="https://nixos.org/"
              ID=nixos
              NAME=NixOS
              SUPPORT_URL="https://nixos.org/community.html"
            '')
            # Add a user at the default user ID, to avoid issues with root
            # files for root dockerd
            (pkgs.dockerTools.fakeNss.override {
              extraPasswdLines = [ "vscode:x:1000:1000:vs code:/home/vscode:/bin/sh" ];
              extraGroupLines = [ "vscode:x:1000:" ];
            })
            # VS Code runs its own Node JS for the VS Code server, which we
            # cannot patch so we use the nix-ld dynamic linker as the docker OS
            # dynamic linker, see NIX_LD and NIX_LD_LIBRARY_PATH below
            (pkgs.runCommand "nix-ld-linker" { } ''
              ldpath="$(cat ${pkgs.nix-ld}/nix-support/ldpath)"
              mkdir -p "$out/$(dirname "$ldpath")"
              ln -s ${pkgs.nix-ld}/libexec/nix-ld "$out/$ldpath"
            '')
            # Some packages VS Code requires for various commands
            pkgs.file
            pkgs.findutils
            pkgs.getent
            pkgs.gnugrep
            pkgs.gnused
            pkgs.gnutar
            pkgs.gzip
            pkgs.less
            pkgs.procps
            pkgs.ripgrep
            pkgs.shadow
          ];
        # Compatibility for devcontainer
        NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
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
        ];
      };
    };
  };

  # https://devenv.sh/packages/
  packages =
    typst-env
    ++ pages-env
    ++ ocaml-env
    ++ [
      pkgs.skopeo
      pkgs.git
      pkgs.pdfpc
      pkgs.obs-studio
    ];

  env = {
    TYPST_PACKAGE_PATH = self.devenv.outputs.typst-packages;
    TYPST_FONT_PATHS = lib.makeSearchPathOutput "out" "share/fonts" [
      pkgs.nerd-fonts.caskaydia-cove
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
    ];
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
