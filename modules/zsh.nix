{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ssh = "TERM=xterm-256color ssh";
      ff = "fastfetch";
    };
    initContent = ''
    HISTSIZE=10000
    SAVEHIST=10000
    HISTCONTROL=ignoredups
    HISTFILE=~/.zsh_history

    autoload -U compinit
    compinit

    autoload -U up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    bindkey "^[[A" up-line-or-beginning-search
    bindkey "^[[B" down-line-or-beginning-search

    setopt AUTO_CD  
    setopt NOCLOBBER
    setopt APPEND_HISTORY
    setopt INC_APPEND_HISTORY

    export PATH="$HOME/Scripts:$PATH"

    PROMPT="%F{blue}%n@%m%f %F{blue}%~ %f"
    '';
  };

}
