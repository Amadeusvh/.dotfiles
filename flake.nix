{
  # CEREAL REAL
  description = "Amadeus Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    home-manager.url = "github:rycee/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... }@attrs: {
    nixosConfigurations = {
      "amadeus-pc" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./modules/common
          ./modules/development
          ./modules/networking
          ./modules/sound
          ./amadeus-pc/configuration.nix
          ./amadeus-pc/hardware-configuration.nix
        ];
      };
    };
  };
}
