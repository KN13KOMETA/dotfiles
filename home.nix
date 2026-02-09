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

  # SHELL BEGIN
  programs.zsh = import ./programs/zsh {
    inherit config;
    inherit pkgs;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./dotfiles/oh-my-posh/kometa.omp.toml;
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
  # SHELL END
}
