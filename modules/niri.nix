{ config, pkgs, ... }:
{
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
      outputs."DP-4" = {
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
      outputs."DP-5" = {
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
        "Mod+Shift+W" = {
          action.spawn = "brave";
          hotkey-overlay.title = "Open alternative Web Browser: brave";
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
      debug = {
        wait-for-frame-completion-in-pipewire = [];
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
}
