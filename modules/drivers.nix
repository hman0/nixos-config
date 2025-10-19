{ config, lib, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;

      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0"; 
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-utils
        mesa
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        nvidia-vaapi-driver
        libva-utils
        mesa
      ];
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvidia-run" ''
      #!/usr/bin/env bash
      __NV_PRIME_RENDER_OFFLOAD=1 \
      __GLX_VENDOR_LIBRARY_NAME=nvidia \
      __VK_LAYER_NV_optimus=NVIDIA_only \
      "$@"
    '')
  ];
}

