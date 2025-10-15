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
      ];
      config = {
        common = {
          default = [ "gnome" ];
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
        swaylock = {};
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

