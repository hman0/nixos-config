{ config, pkgs, catppuccin, niri, inputs, secrets, ... }:
{
  home.username = "hman";
  home.homeDirectory = "/home/hman";

  home.stateVersion = "25.05"; 

  home.file."Scripts".source = ./hman/dotfiles/Scripts;
  xdg.configFile."eww".source = ./hman/dotfiles/eww;

  gtk = {
    enable = true;
    iconTheme = {
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

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=13";
        pad = "10x10";
      };
      cursor = {
        color = "181926 f4dbd6";
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

  programs.niri = {
    enable = true;
    settings = {
      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      input = {
        warp-mouse-to-focus.enable = true;
        focus-follows-mouse.enable = true;
        focus-follows-mouse.max-scroll-amount="100%";
        keyboard = {
          xkb.layout = "gb";
          numlock = true;
          repeat-delay = 200;
          repeat-rate = 50;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse = {
          accel-speed = 1.0;
          accel-profile = "flat";
        };
      };
      outputs."DP-1" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 164.999;
        };
        scale = 1;
        position = {
          x = -750;
          y = 1080;
        };
      };
      outputs."DP-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        }; 
        scale = 1;
        position = {
          x = 0;
          y = 0;
        };
      };
      layout = {
        gaps = 16;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
        default-column-width.proportion = 0.5;
        focus-ring = {
          enable = false;
        };
        border = {
          enable = true;
          width = 4;
          active.color = "#ed8796";
          inactive.color = "#363a4f";
        };
        shadow = {
          softness = 30;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          color = "#0007";
        };
      };
      spawn-at-startup = [
        {
          command = [ "eww" "open" "bar0" ];
        } {
          command = [ "eww" "open" "bar1" ];
        } {
          command = [ "swaybg" "-i" "/home/hman/Pictures/Wallpapers/evening-sky.png" ];
        } {
          command = [ "xwayland-satellite" ];
        } {
          command = [ "dunst" ];
        }
      ]; 
      window-rules = [
        {
          matches = [
            {
              app-id = "librewolf$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          geometry-corner-radius.bottom-left = 12.0;
          geometry-corner-radius.top-left = 12.0;
          geometry-corner-radius.top-right = 12.0;
          geometry-corner-radius.bottom-right = 12.0;
          clip-to-geometry = true;
        }
      ]; 
      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay; 

        "Mod+Return" = {
          action.spawn = "foot";
          hotkey-overlay.title = "Open a Terminal: foot";
        };
        "Mod+D" = {
          action.spawn = "fuzzel";
          hotkey-overlay.title = "Run an Application: fuzzel";
        };
        "Mod+W" = {
          action.spawn = "librewolf";
          hotkey-overlay.title = "Open a Web Browser: librewolf";
        };
        "Mod+Alt+L" = {
          action.spawn = "swaylock";
          hotkey-overlay.title = "Lock the Screen: swaylock";
        };

        "XF86AudioRaiseVolume" = {
          action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; 
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ toggle";
          allow-when-locked = true;
        };

        "XF86MonBrightnessUp" = {
          action.spawn = "brightnessctl s +5%";
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = "brightnessctl s -5%";
          allow-when-locked = true;
        };

        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };

        "Mod+Q".action = close-window;

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down; 

        "Mod+Shift+H".action = move-column-left; 
        "Mod+Shift+J".action = move-window-up; 
        "Mod+Shift+K".action = move-window-down; 
        "Mod+Shift+L".action = move-column-right;

        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+J".action = focus-monitor-down;
        "Mod+Ctrl+K".action = focus-monitor-up; 
        "Mod+Ctrl+L".action = focus-monitor-right; 
        
        "Mod+Space" = {
          action.spawn = "/home/hman/Scripts/monitor-focus-toggle.sh";
        };

        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up; 
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right; 

        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+BracketLeft".action=consume-or-expel-window-left; 
        "Mod+BracketRight".action=consume-or-expel-window-right; 
        "Mod+Comma".action=consume-window-into-column;
        "Mod+Period".action=expel-window-from-column;

        "Mod+R".action=switch-preset-column-width;
        "Mod+Shift+R".action=switch-preset-window-height;
        "Mod+Ctrl+R".action=reset-window-height; 
        "Mod+F".action=maximize-column; 
        "Mod+Shift+F".action=fullscreen-window;
        "Mod+Ctrl+F".action=expand-column-to-available-width;
        "Mod+C".action=center-column; 
        "Mod+Ctrl+C".action=center-visible-columns;

        "Mod+Minus".action.set-column-width = "-10%"; 
        "Mod+Equal".action.set-column-width = "+10%"; 
        "Mod+Shift+Minus".action.set-window-height = "-10%"; 
        "Mod+Shift+Equal".action.set-window-height = "+10%";  

        "Mod+V".action=toggle-window-floating; 
        "Mod+Shift+V".action=switch-focus-between-floating-and-tiling;

        "Shift+Mod+S".action=screenshot;
        "Print".action.screenshot-screen = [];
        "Mod+Ctrl+S".action=screenshot-window; 

        "Mod+Home".action=focus-column-first;
        "Mod+End".action=focus-column-last; 
        "Mod+Shift+Home".action=move-column-to-first;
        "Mod+Shift+End".action=move-column-to-last; 

        "Mod+Escape" = {
          action=toggle-keyboard-shortcuts-inhibit;
          allow-inhibiting = false;
        };
        "Mod+M" = {
          action.quit.skip-confirmation = true;
        };
      };
      cursor = {
        theme = "Bibata-Modern-Ice";
      };
      hotkey-overlay = {
        skip-at-startup = true;
      };
      gestures = {
        hot-corners.enable = false;
      };
      environment = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        ELECTRON_ENABLE_WAYLAND = "1";
        CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "niri";
        NIXOS_OZONE_WL = "1";
        DISPLAY = ":0";
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

  home.packages = with pkgs; [
  ];

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "red";
    gtk.enable = true;
    fuzzel.enable = true;
    dunst.enable = false;
  };
}

