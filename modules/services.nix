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
    gvfs = {
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
    upower = {
      enable = true;	
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
        
        CPU_SCALING_MIN_FREQ_ON_AC = 300000;
        CPU_SCALING_MAX_FREQ_ON_AC = 3000000;
        CPU_SCALING_MIN_FREQ_ON_BAT = 300000;
        CPU_SCALING_MAX_FREQ_ON_BAT = 2400000;        

        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        
        DISK_DEVICES = "nvme0n1";
        DISK_IOSCHED = "none"; 
        
        SATA_LINKPWR_ON_AC = "med_power_with_dipm";
        SATA_LINKPWR_ON_BAT = "min_power";
        
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersave";
        
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        
        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_AUDIO = 1; 
        USB_EXCLUDE_BTUSB = 1; 
        USB_EXCLUDE_PHONE = 1; 
        USB_EXCLUDE_PRINTER = 1;
        USB_EXCLUDE_WWAN = 0; 
        
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";
        
        WOL_DISABLE = "Y";
        
        NATACPI_ENABLE = 1;
        TPACPI_ENABLE = 1;
        TPSMAPI_ENABLE = 1;
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

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = false;
    };
  };

  systemd = {
    targets = {
      sleep = {
        enable = false;
      };
      suspend = {
        enable = false;
      };
    };
  };
}
