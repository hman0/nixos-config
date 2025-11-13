{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    niri.url = "github:sodiboo/niri-flake";
    mango.url = "github:DreamMaoMao/mango";
    mango.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    secrets = {
      url = "/home/hman/nix/secrets";
      flake = false; 
    };
  };

  outputs = inputs@{ self, nixpkgs, catppuccin, home-manager, spicetify-nix, niri, mango, secrets, lanzaboote, chaotic, ... }: 
  let
    secretsData = import "${secrets}/secrets.nix";
  in {
    nixosConfigurations.when-they-cry = nixpkgs.lib.nixosSystem {
      specialArgs = { 
        inherit inputs;
        secrets = secretsData; 
      };

      modules = [ 
        ./configuration.nix
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
              ./modules/nvim.nix
              inputs.spicetify-nix.homeManagerModules.default
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

        lanzaboote.nixosModules.lanzaboote

        ({ pkgs, lib, ... }: {
          environment.systemPackages = [
            pkgs.sbctl
          ];

          boot.loader.systemd-boot.enable = lib.mkForce false;

          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };
        })

        chaotic.nixosModules.default
      ];
    };
  };
} 
