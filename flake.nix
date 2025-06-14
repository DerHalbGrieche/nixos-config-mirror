{
  description = "My NixOS Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixvim.url = "github:derhalbgrieche/nixvim";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
  in {
    inherit lib;
    templates = import ./templates;
    # NixOS configuration entrypoint
    formatter = pkgs: pkgs.alejandra;
    overlays = import ./overlays {inherit inputs outputs;};

    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      laptopUni = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/laptopUni/configuration.nix inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e15-intel];
      };
      server = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/server/configuration.nix];
      };
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/desktop/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "vasilis@laptopUni" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/vasilis/home.nix ./home-manager/vasilis/laptopUni.nix];
      };
      "rizzler@server" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/rizzler/home.nix];
      };
      "vasilis@desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/vasilis/home.nix ./home-manager/vasilis/desktop.nix];
      };
    };
  };
}
