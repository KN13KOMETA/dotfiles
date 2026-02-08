let user = "nixtest";
in { config, pkgs, ... }: {
  home = {
    username = user;
    homeDirectory = "/home/" + user;
  };

  # Check hm release notes before changing
  home.stateVersion = "25.11";

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

  home.sessionVariables = { EDITOR = "nvim"; };

  home.shellAliases = { hm = "home-manager"; };

  home.packages = with pkgs; [
    (writeShellScriptBin "hello" ''
      echo "Be Quiet, ${config.home.username}"
      echo "KOMETA is here"
      echo ""
      echo "If completions is not working run \"rm -f ~/.zcompdump; compinit\""
    '')
    nix-prefetch-git
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Setup shell
  programs.zsh = {
    enable = true;

    # NOTE: Uncomment when debugging
    # zprof.enable = true;

    history = {
      # Limits memory
      size = 6666;
      # Limits file
      save = 6666;

      append = true;
      share = true;
      ignoreSpace = true;

      ignoreAllDups = true;
      ignoreDups = true;
      saveNoDups = true;
      findNoDups = true;
    };

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Ignores insecure files and dirs
    completionInit = "autoload -U compinit && compinit -i";

    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "989d0445450b8e79b3cde2da3b7f4bb54934354c";
          sha256 = "0v1djgrqfn01b40xfr1c0i9h1aca8l32m8ns0dsxqhvjyzy0m0f4";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "747c15de85a38748b28c29ac65616137dbb4c8b6";
          sha256 = "0y3l8cinmy7k6jc6qmpnwp5h1m0fix2x2vn8ifmadji3d6klbaw1";
        };
      }
    ];

    initContent = ''
      # Lowercase completion work on both lowercase and uppercase
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      # Color completion same as "ls --color"
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      # Shows directory content in preview when using cd (zoxide)
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./files/.config/oh-my-posh/custom.toml;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
