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
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    BROWSER = "librewolf";
    EDITOR = "nvim";
  };
  
  environment.etc."/wayland-sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=Niri
    Comment=Niri scrollable-tiling Wayland compositor
    Exec=systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP; systemctl --user start graphical-session.target; exec niri-session
    Type=Application
    DesktopNames=niri
  '';
  environment.etc."/wayland-sessions/mango.desktop".text = ''
    [Desktop Entry]
    Name=MangoWC
    Comment=Mango Wayland compositor
    Exec=systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP; systemctl --user start graphical-session.target; exec mango
    Type=Application
    DesktopNames=mango
  '';
  networking.hostName = "when-they-cry"; 
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];
  };

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
  };
  
  # networking.wg-quick.interfaces = {
  #   protonvpn = {
  #     address = [ "10.2.0.2/32" ];
  #     dns = [ "10.2.0.1" ];
  #     privateKeyFile = "/root/wireguard-keys/privatekey";
  #     listenPort = 51820;
  #
  #     peers = [
  #       {
  #         publicKey = "WbRD+D0sEqI7tlTIycY4QVlSgv3zPWCWmx0Z+UA08gI=";
  #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         endpoint = "146.70.179.34:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
  
  
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
   extraGroups = [ "wheel" "video" "audio" "disk" "docker" "tty" "input" "networkmanager" ];
   shell = pkgs.zsh;
   uid = 1001;
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; 
}
