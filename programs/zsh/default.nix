{
  config,
  pkgs,
  inputs,
  ...
}:
{
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
      src = inputs.zsh-completions;
    }
    {
      name = "fzf-tab";
      src = inputs.fzf-tab;
    }
    {
      name = "zsh-vi-mode";
      src = inputs.zsh-vi-mode;
    }
  ];

  # TODO: Check if this works
  sessionVariables = {
    ZVM_SYSTEM_CLIPBOARD_ENABLED = true;
  };

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
