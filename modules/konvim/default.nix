{
  config.vim = {
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
