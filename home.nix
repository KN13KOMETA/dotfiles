{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/programs/zsh
    ./modules/programs/fastfetch
  ];

  home.file = {
    # TODO: Write wezterm config
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink ./files/.config/wezterm;
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

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # SHELL BEGIN

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
}
