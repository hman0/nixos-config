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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;

  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.device = "nodev";
  #
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable gnome-keyring (needed for secrets, e.g., for apps like Chromium or Keychain access)
  services.gnome.gnome-keyring.enable = true;

  services.mullvad-vpn.enable = true;

  services.flatpak.enable = false;

  xdg.portal.enable = true;

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-gnome
  ];

  xdg.portal.config = {
    common = {
      default = [ "gtk" "gnome" ];
    };
    niri = {
      default = [ "gtk" "gnome" ]; 
    };
  };

  networking.hostName = "when-they-cry"; # Define your hostname.
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
    useXkbConfig = true; # use xkb.options in tty.
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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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
   extraGroups = [ "wheel" "video" "audio" "disk" "docker" ]; # Enable ‘sudo’ for the user.
   shell = pkgs.zsh;
   uid = 1001;
  };

  programs.zsh = {
    enable = true;
  };

  programs.steam.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  
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
    wget
    bash
    wpa_supplicant
    fastfetch
    neovim
    git
    gnupg
    pinentry-tty
    foot
    librewolf
    eww
    pamixer
    playerctl
    swaybg
    grim
    brightnessctl
    acpi
    cbonsai
    cava
    dconf
    bibata-cursors
    xsettingsd
    vesktop
    fuzzel
    ffmpeg-full
    glxinfo
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    gnome-keyring
    whitesur-icon-theme
    spotify
    steam
    gamemode
    protonup-qt
    mangohud
    xwayland-satellite
    qbittorrent
    dunst
    gamescope
    bottles
    unrar-free
    mpv
    unzip
    tldr
    wl-clipboard
    swaylock
    nodejs
    nodePackages.nodemon
    efibootmgr
    sbctl
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.packageOverrides = pkgs: {
    bottles = pkgs.bottles.override {
      removeWarningPopup = true;
    };
  };

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

