{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    niri.url = "github:sodiboo/niri-flake";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    secrets = {
      url = "/home/hman/nix/secrets";
      flake = false; 
    };
  };
  outputs = inputs@{ self, nixpkgs, catppuccin, home-manager, spicetify-nix, niri, secrets, lanzaboote, ... }: 
  let
    secretsData = import "${secrets}/secrets.nix";
  in
  {
    nixosConfigurations.when-they-cry = nixpkgs.lib.nixosSystem {
      specialArgs = { 
        inherit inputs;
        secrets = secretsData; 
      };
      modules = [ 
        ./configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hman = {
            imports = [
              ./hman.nix
              ./modules/niri.nix
              inputs.spicetify-nix.homeManagerModules.default
              catppuccin.homeModules.catppuccin
              niri.homeModules.niri
            ];
            _module.args = { inherit inputs; secrets = secretsData; };
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
      ];
    };
  };
}
