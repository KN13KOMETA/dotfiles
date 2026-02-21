{ inputs, runtime-path, ... }:
{
  config.vim = {
    additionalRuntimePaths = [ runtime-path ];

    # SPELL SETUP
    # NOTE: Disable `spellfile.vim`, we manage spell files with flakes instead
    luaConfigRC.disable-spellfile-plugin = "vim.g.loaded_spellfile_plugin = 1";
    spellcheck = {
      enable = true;
      languages = [
        "en"
        "ru"
      ];
    };

    clipboard = {
      enable = true;
      registers = "unnamedplus";
    };

    options = {
      # TODO: sort this
      cursorlineopt = "number";

      mouse = "a";

      shiftwidth = 0;
      tabstop = 2;

      # TODO: dynamic wrap
      wrap = false;

      cursorline = true;

      ignorecase = true;
      smartcase = true;

      guifont = "IntoneMono NF:h11.2";
    };
  };
}
