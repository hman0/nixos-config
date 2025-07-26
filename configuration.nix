# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, secrets, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  system.activationScripts.debug-secrets = ''
    echo "Available secrets: ${builtins.toJSON (builtins.attrNames secrets)}"
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest; # binary kernel

  # boot.kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {
  #   mArch = "ZEN4"; 
  # };
  #
  # services.scx.enable = true;

  boot.kernelParams = [
    "nvidia_drm.modeset=1" 
    "nvidia_drm.fbdev=1" 
    "systemd.unified_cgroup_hierarchy=1"
  ];

  boot.loader.systemd-boot.enable = true;

  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.device = "nodev";
  #
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS support
  # boot.supportedFilesystems = [ "zfs" ];
  # boot.zfs.forceImportRoot = false; 
  # networking.hostId = "da3429c1";

  # Services
  services.dbus.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.mullvad-vpn.enable = true;
  services.flatpak.enable = true;

  xdg.portal.enable = true;
  
  #xdg.portal.xdgOpenUsePortal = true;
 
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome  
  ];

  xdg.portal.config = {
    common = {
      default = [ "gnome" ];
    };
  };

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    XDG_CURRENT_DESKTOP = "niri";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  networking.hostName = "when-they-cry"; # Define your hostname.
  networking.wireless = {
    enable = true;
    networks = {
      "${secrets.ssid_vm}" = { psk = secrets.psk_vm; priority = 20; };
    };
  };

  networking.firewall.enable = false;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "uk";
    useXkbConfig = true; # use xkb.options in tty.
    earlySetup = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true; 
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-utils
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      libva-utils
    ];
  };

  users.users.hman = {
   isNormalUser = true;
   extraGroups = [ "wheel" "video" "audio" "disk" "docker" "tty" ]; # Enable ‘sudo’ for the user.
   shell = pkgs.zsh;
   uid = 1001;
  };

  programs.zsh = {
    enable = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.steam.enable = true;
  
  security.doas.enable = true;
  security.doas.extraRules = [
    {
      groups = [ "wheel" ];
      noPass = true; 
      keepEnv = true;
    }
  ];

  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    bash
    dash
    wpa_supplicant
    neovim
    gnupg
    pinentry-tty
    foot
    pamixer
    pulsemixer
    playerctl
    swaybg
    grim
    brightnessctl
    acpi
    efibootmgr
    sbctl
    mission-center
  ];

  services.flatpak = {
    packages = [
      "org.vinegarhq.Sober"
      "com.github.tchx84.Flatseal"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      whatsapp-emoji-font
    ];
    fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "WhatsApp Emoji" ];
      serif = [
        "Noto Sans"
        "Noto Sans CJK SC" 
        "Noto Sans CJK TC"
        "Noto Sans CJK JP"
        "Noto Sans CJK KR"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"  
      ];
      monospace = [
        "JetBrainsMono Nerd Font Mono"
        "JetBrains Mono"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono"
      ];
    };
  };
};

  services.openssh.enable = true;

  system.stateVersion = "25.05"; 
}

