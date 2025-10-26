{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-x13s.url = "github:BrainWart/x13s-nixos";
    catppuccin.url = "github:catppuccin/nix";
    niri.url = "github:sodiboo/niri-flake";
    mango.url = "github:DreamMaoMao/mango";
    mango.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    secrets = {
      url = "/home/hman/nix/secrets";
      flake = false; 
    };
  };
  outputs = inputs@{ self, nixpkgs, nixos-x13s, catppuccin, home-manager, niri, mango, secrets, chaotic, ... }: 
  let
    secretsData = import "${secrets}/secrets.nix";
  in {
    nixosConfigurations.when-they-scry = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { 
        inherit inputs;
        secrets = secretsData; 
      };
      modules = [ 
        ./configuration.nix
        nixos-x13s.nixosModules.default
        {
          nixos-x13s.enable = true;
	  nixos-x13s.kernel = "mainline";
        }
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        inputs.mango.nixosModules.mango
        {
          programs.mango.enable = true;
        }
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.hman = {
            imports = [
              ./hman.nix
              ./modules/niri.nix
              ./modules/mango.nix
              catppuccin.homeModules.catppuccin
              niri.homeModules.niri
              mango.hmModules.mango
            ];
            _module.args = {
              inherit inputs;
              secrets = secretsData;
            };
          };
        }
        chaotic.nixosModules.default
      ];
    };
  };
} 
