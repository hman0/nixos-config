{ config, lib, pkgs, secrets, ... }:

{
  boot = {
    kernelParams = [
      "systemd.unified_cgroup_hierarchy=1"
      "clk_ignore_unused"
      "pd_ignore_unused"
      "arm64.nopauth"
      "efi=noruntime"
    ];
    
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };
}
