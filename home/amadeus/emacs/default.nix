{ nix-doom-emacs, ... }:
{
  # TODO: Find out why this import is causing problems.
  # This import is necessary to setup doom emacs
  # inside the home manager
  # imports = [ nix-doom-emacs.hmModule ];
  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom.d;
  # };
}
