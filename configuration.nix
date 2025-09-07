{ config, lib, pkgs, secrets, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./modules/services.nix
      ./modules/boot.nix
      ./modules/drivers.nix
      ./modules/software.nix
    ];

  system.activationScripts.debug-secrets = ''
    echo "Available secrets: ${builtins.toJSON (builtins.attrNames secrets)}"
  '';

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    XDG_CURRENT_DESKTOP = "niri";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    BROWSER = "librewolf";
  };
  
  environment.etc."/wayland-sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=Niri
    Comment=Niri scrollable-tiling Wayland compositor
    Exec=dbus-run-session niri --session
    Type=Application
    DesktopNames=niri
  '';


  networking.hostName = "when-they-cry"; 
  networking.wireless = {
    enable = true;
    networks = {
      "${secrets.ssid_vm}" = { psk = secrets.psk_vm; priority = 20; };
    };
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "uk";
    useXkbConfig = true; 
    earlySetup = true;
  };

  users.users.hman = {
   isNormalUser = true;
   extraGroups = [ "wheel" "video" "audio" "disk" "docker" "tty" "input" ];
   shell = pkgs.zsh;
   uid = 1001;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05"; 
}

