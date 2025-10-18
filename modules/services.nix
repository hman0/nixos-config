{ config, lib, pkgs, ... }:
{
  services = {
    dbus = {
      enable = true;
    };
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
    mullvad-vpn = {
      enable = true;
    };
    openssh = {
      enable = true;
    };
    pipewire = {
      enable = true;
      pulse = {
        enable = true;
      };
    };
    udisks2 = {
      enable = true;
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "hman";
      dataDir = "/home/hman";
    };
    displayManager = {
      ly = {
        enable = true;
        settings = {
          waylandsessions = "/etc/wayland-sessions";
        };
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      config = {
        common = {
          default = [ "gnome" ];
        };
        niri = {
          default = [ "gnome" ];
        };
        wlr = {
          default = [ "wlr" ];
        };
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  security = {
    pam = {
      services = {
        login = {
          enableGnomeKeyring = true;
        };
        ly = {
          enableGnomeKeyring = true;
        };
        swaylock = {
          enableGnomeKeyring = true;
        };
      };
    };
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ]; 
          noPass = true;
          keepEnv = true;
        }
      ];
    };
  };
}

