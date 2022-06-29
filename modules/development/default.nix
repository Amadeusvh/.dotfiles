{ pkgs, lib, ... }:
let
  emacs = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacsGit;
    extraEmacsPackages = epkgs:
      with epkgs; [
        vterm
        magit
        org
        tide
        neotree
        hl-todo
        doom-modeline
        popup
        vi-tilde-fringe
        parinfer-rust-mode
        multiple-cursors
        consult
        embark-consult
        dockerfile-mode
        docker-compose-mode
        ansible
        editorconfig
        gist
        alchemist
      ];
  });
in
{
  environment.variables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    # Development
    vscode
    dbeaver
    vim
    elmPackages.elm-format
    gnumake
    libtool
    libvterm
    nixpkgs-fmt
    postman
    shellcheck
    shfmt
    elixir_1_13
    yarn
    nushell
    swiProlog

    cmigemo
    ansible

    # rtags
    ripgrep

    # nix-doom-emacs.doom-emacs
    nodejs
    nodePackages.stylelint
    nodePackages.js-beautify
    emacs28Packages.vterm
    mu
    zig
    python39Packages.nose
    cargo
    rustc
    rustfmt
    rust-analyzer
    rust-code-analysis
    rustracer
    ocamlPackages.utop
    python3Full
    black
    icr
    fsharp
    haskellPackages.Cabal_3_6_3_0
    haskellPackages.brittany
    haskellPackages.hlint
    haskellPackages.hoogle
    haskellPackages.nixfmt
    clj-kondo
    terraform
    metals
    ruby_3_1

    racket
    markdown-anki-decks

    podman-compose

    cmake
    gcc

    # GI
    jq
    fd
    xdelta
  ];

  #nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url =
  #      "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  #  }))
  #];

  services.emacs.enable = true;
  services.postgresql.enable = true;
  services.postgresql.authentication = lib.mkForce ''
    # Generated file; do not edit!
    local all all              trust
    host  all all 127.0.0.1/32 trust
    host  all all ::1/128      trust
  '';
  systemd.enableUnifiedCgroupHierarchy = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation = {
    podman = {
      enable = true;
      dockerSocket = { enable = true; };
      dockerCompat = true;
    };
  };

  # Make containers work properly
  systemd.services."user@".serviceConfig = { Delegate = "yes"; };

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  security.pam.enableSSHAgentAuth = true;
}
