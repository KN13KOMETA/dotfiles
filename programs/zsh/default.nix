{ config, pkgs, ... }: {
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
    {
      name = "zsh-vi-mode";
      src = pkgs.fetchFromGitHub {
        owner = "jeffreytse";
        repo = "zsh-vi-mode";
        rev = "08bd1c04520418faee2b9d1afbc410ee1a59a8f1";
        sha256 = "0kkm91a37yxbgxcbzg8fcr8pn380myg7zf913wwfnm2mbh4lgmjr";
      };
    }
  ];

  # TODO: Check if this works
  sessionVariables = { ZVM_SYSTEM_CLIPBOARD_ENABLED = true; };

  initContent = ''
    # Lowercase completion work on both lowercase and uppercase
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    # Color completion same as "ls --color"
    zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

    # Shows directory content in preview when using cd (zoxide)
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
  '';
}
