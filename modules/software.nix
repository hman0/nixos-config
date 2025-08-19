{ config, lib, pkgs, secrets, ... }:
{
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
    pamixer
    pulsemixer
    efibootmgr
    sbctl
    xdg-utils
  ];

  programs = {
    dconf = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamescope = { 
      enable = true;
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
}

