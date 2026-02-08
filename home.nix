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

  home.packages = with pkgs;
    [
      (writeShellScriptBin "hello" ''
        echo "Be Quiet, ${config.home.username}"
        echo "KOMETA is here"
      '')
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Setup shell
  programs.zsh = {
    enable = true;

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
