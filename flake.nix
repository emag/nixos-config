{
  description = "NixOS configuration for Dell XPS 15 7590";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-nix.url = "github:SecBear/codex-nix";

    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      codex-nix,
      mattpocock-skills,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix

          nixos-hardware.nixosModules.dell-xps-15-7590-nvidia

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;


            home-manager.extraSpecialArgs = {
              inherit codex-nix mattpocock-skills;
            };

            home-manager.backupFileExtension = "backup";

            home-manager.users.emag = import ./home.nix;
          }
        ];
      };
    };
}

