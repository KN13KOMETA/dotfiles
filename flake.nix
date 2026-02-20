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

    # https://ftp.nluug.nl/vim/runtime/spell
    vim-runtime-spell-en = {
      url = "https://ftp.nluug.nl/vim/runtime/spell/en.utf-8.spl";
      flake = false;
    };
    vim-runtime-spell-ru = {
      url = "https://ftp.nluug.nl/vim/runtime/spell/ru.utf-8.spl";
      flake = false;
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
      konvimRuntime = pkgs.linkFarm "nvim-runtime" [
        {
          name = "spell/en.utf-8.spl";
          path = inputs.vim-runtime-spell-en;
        }
        {
          name = "spell/ru.utf-8.spl";
          path = inputs.vim-runtime-spell-ru;
        }
      ];
      konvim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          (import ./modules/konvim {
            inherit inputs;
            runtime-path = konvimRuntime;
          })
        ];
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
