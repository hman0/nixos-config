{ config, pkgs, lib, catppuccin, niri, inputs, secrets, ... }:
{
  home.username = "hman";
  home.homeDirectory = "/home/hman";

  home.stateVersion = "25.05"; 

  home.file."Scripts".source = ./hman/dotfiles/Scripts;
  xdg.configFile."eww".source = ./hman/dotfiles/eww;
  xdg.configFile."nvim".source = ./hman/dotfiles/nvim;
  home.file."Pictures/Wallpapers".source = ./hman/dotfiles/Wallpapers;
  home.file."Pictures/Wallpapers".recursive = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-macchiato-red-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "red" ];
        size = "standard";
        variant = "macchiato";
      };
    };
    iconTheme = lib.mkForce {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum"; 
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    x11.enable = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "xiong-chiamiov-plus";
      plugins = [ "git" ];
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
    echo "-----------------------------------------------------"
    fastfetch --config nix 
    echo "-----------------------------------------------------"
    '';
  };

  home.file.".local/share/fastfetch/presets/nix.jsonc" = {
    text = builtins.toJSON {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      modules = [
        "title"
        "os" 
        "kernel"
        "uptime"
        "packages"
        "shell"
        "wm"
      ];
      logo = {
        type = "small";
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=16";
        icon-theme = "WhiteSur-dark";
      };
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 400;
        offset = "5x15";
        scale = 2;
        font = "JetBrainsMono Nerd Font 12";
        frame_color = "#ed8796";
        separator_color = "#ed8796";
        highlight = "#8aadf4";
      };
      urgency_low = {
        background = "#24273a";
        foreground = "#cad3f5";
      };
      urgency_normal = {
        background = "#24273a";
        foreground = "#cad3f5";
      };
      urgency_high = {
        background = "#24273a";
        foreground = "#cad3f5";
      };
    };
  };

  programs.swaylock = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=13";
        pad = "10x10";
      };
      colors = {
        alpha = "0.9";
        foreground = "cad3f5";
        background = "24273a";
        regular0 = "494d64";
        regular1 = "ed8796";
        regular2 = "a6da95";
        regular3 = "eed49f";
        regular4 = "8aadf4";
        regular5 = "f5bde6";
        regular6 = "8bd5ca";
        regular7 = "b8c0e0";
        bright0 = "5b6078";
        bright1 = "ed8796";
        bright2 = "a6da95";
        bright3 = "eed49f";
        bright4 = "8aadf4";
        bright5 = "f5bde6";
        bright6 = "8bd5ca";
        bright7 = "a5adcb";
        "16" = "f5a97f";
        "17" = "f4dbd6";
        selection-foreground = "cad3f5";
        selection-background = "454a5f";
        search-box-no-match = "181926 ed8796";
        search-box-match = "cad3f5 363a4f";
        jump-labels = "181926 f5a97f";
        urls = "8aadf4";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "hman0";
    userEmail = secrets.git_email;
  };
  
  programs.spicetify = 
  let 
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in 
  {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";
  };

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    comment = "Music streaming service";
    icon = "spotify";
    exec = "spotify --ozone-platform=x11 %U";
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    mimeType = [ "x-scheme-handler/spotify" ];
  };

  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=x11" # Use XWayland 
    ];
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    fastfetch
    cava
    dconf
    bibata-cursors
    xsettingsd
    vesktop
    fuzzel
    ffmpeg-headless
    xdg-desktop-portal-gnome
    gnome-keyring
    whitesur-icon-theme
    steam
    gamemode
    game-devices-udev-rules
    mangohud
    xwayland-satellite
    dunst
    gamescope
    unrar-free
    mpv
    wget
    unzip
    p7zip
    tldr
    wl-clipboard
    wtype
    swaylock
    nodejs
    nodePackages.nodemon
    nautilus
    eww
    librewolf
    scrcpy
    transmission_4-gtk
    celluloid
    superTuxKart
    prismlauncher
    playerctl
    brightnessctl
    swaybg
    pinta
  ];

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "red";
    fuzzel.enable = true;
    dunst.enable = false;
    foot.enable = false;
  };
}
