let
  user = "kometa13";
in
{ config, pkgs, ... }:
{
  home = {
    username = user;
    homeDirectory = "/home/" + user;
  };

  # Check hm release notes before changing
  home.stateVersion = "25.11";

  home.file = {
    # TODO: Write wezterm config
    ".config/wezterm" = {
      source = ./files/.config/wezterm;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    abc = "echo {a..z}";
    abc-ru = "echo {а..я}";

    c = "clear";

    hm = "home-manager";
    hms = "hm switch";

    ls = "ls --color";
    ll = "ls -alF";
    la = "ls -A";
    l = "ls -CF";
    lal = "ls -ACF";

    n = "nvim";

    f = "fastfetch";
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "hello" ''
      echo "Be Quiet, ${config.home.username}"
      echo "KOMETA is here"
      echo ""
      echo "If completions is not working run \"rm -f ~/.zcompdump; compinit\""
    '')

    nix-prefetch-git

    git
    curl
    gawk

    nerd-fonts.intone-mono

    # Editor
    neovim

    # Terminal
    wezterm

    # Languages
    nodejs
    zig
    rustc

    # Building
    cmake
    gnumake
    ninja

    # QOL
    lazygit
    tree
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # SHELL BEGIN
  programs.zsh = import ./programs/zsh { inherit config pkgs; };

  # TODO: Different palette support
  # TODO: Write exit codes
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

  # TODO: Take a look at zellij, ghostty and micro

  programs.fastfetch = import ./programs/fastfetch { inherit config pkgs; };
}
