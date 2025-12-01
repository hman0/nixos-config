{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
     plugins = [
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-z";
        file = "zsh-z.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "agkozak";
          repo = "zsh-z";
          rev = "cf9225feebfae55e557e103e95ce20eca5eff270";
          sha256 = "sha256-C79eSOaWNHSJiUGmHzu9d0zO0NdW+dktK21a2niPZm0=";
        };
      }
    ];
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    completionInit = ''
      autoload -Uz compinit
      setopt EXTENDEDGLOB
      for dump in ~/.zcompdump(#qN.m1); do
        compinit
        if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
          zcompile "$dump"
        fi
      done
      compinit -C
      unsetopt EXTENDEDGLOB
    '';
    shellAliases = {
      ssh = "TERM=xterm-256color ssh";
      ff = "fastfetch";
      cd = "z";
    };
    history = {
      size = 1000;
      save = 1000;
      ignoreAllDups = true;
    };
    initContent = ''
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down

      setopt AUTO_CD  
      setopt NOCLOBBER
      
      export PATH="$HOME/Scripts:$PATH"
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="none"
      PROMPT="%F{blue}%n@%m%f %F{blue}%~ %f"
    '';
  };
}
