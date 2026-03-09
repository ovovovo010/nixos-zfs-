{
  description = "user1 home-manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      homeConfigurations.user1 = home-manager.lib.homeManagerConfiguration {
        inherit system;
        modules = [ ./home.nix ];
        pkgs = nixpkgs.legacyPackages.${system};
      };
    };
}
