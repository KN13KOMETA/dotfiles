{
  description = "Home Manager configuration of KOMETA";

  # https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-flake.html#flake-inputs
  # https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-flake.html#flake-references
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };
    fzf-tab = {
      url = "github:Aloxaf/fzf-tab";
      flake = false;
    };
    zsh-vi-mode = {
      url = "github:jeffreytse/zsh-vi-mode";
      flake = false;
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      system = "x86_64-linux";
      user = {
        main = "kometa13";
      };
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      nvfConfig = {
        config.vim = {
          theme.enable = true;
        };
      };
      konvim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ nvfConfig ];
      };
    in
    {
      packages.${system}.konvim = konvim.neovim;

      homeConfigurations = {
        ${user.main} = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home = {
                username = user.main;
                homeDirectory = "/home/" + user.main;
                # Check hm release notes before changing
                stateVersion = "25.11";
              };
            }
            { home.packages = [ konvim.neovim ]; }
            ./home.nix
          ];

          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
