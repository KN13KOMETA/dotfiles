{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kometa13";
  home.homeDirectory = "/home/kometa13";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Based
    pkgs.git
    pkgs.wget
    pkgs.curl
    pkgs.gawk

    # Editor
    pkgs.neovim

    # Languages
    pkgs.nodejs
    pkgs.zig
    pkgs.rustc

    # Building
    pkgs.cmake
    pkgs.gnumake
    pkgs.ninja

    # QOL
    pkgs.lazygit
    pkgs.tree

    # Other
    pkgs.fastfetch
    pkgs.zinit

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kometa13/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = { EDITOR = "nvim"; };

  home.shellAliases = {
    f = "fastfetch";
    ls = "ls --color";
    c = "clear";
    n = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };

  programs = {
    zsh = {
      enable = true;

      history = {
        size = 6666;

        append = true;
        share = true;
        ignoreSpace = true;

        ignoreAllDups = true;
        ignoreDups = true;
        saveNoDups = true;
        findNoDups = true;
      };

      # TODO: wait till zinit appears in home manager
      # TODO: mayber switch bindkeys
      initContent = ''
        # Default zinit location
        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

        # Source/Load zinit
        source "''${ZINIT_HOME}/zinit.zsh"

        # Add in zsh plugins
        zinit light zsh-users/zsh-syntax-highlighting
        zinit light zsh-users/zsh-completions
        zinit light zsh-users/zsh-autosuggestions
        zinit light Aloxaf/fzf-tab

        # Add in snippets
        zinit snippet OMZP::git
        zinit snippet OMZP::sudo
        zinit snippet OMZP::archlinux
        zinit snippet OMZP::aws
        zinit snippet OMZP::kubectl
        zinit snippet OMZP::kubectx
        zinit snippet OMZP::command-not-found

        # Load completions
        autoload -Uz compinit && compinit

        zinit cdreplay -q

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        # Remove highlight of pasted text
        zle_highlight+=(paste:none)

        # Keybindings
        bindkey -e
        bindkey '^[[A' history-search-backward
        bindkey '^p' history-search-backward
        bindkey '^[[B' history-search-forward
        bindkey '^n' history-search-forward
        bindkey '^[w' kill-region
      '';
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      configFile = "${config.xdg.configHome}/oh-my-posh/custom.toml";
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
