{ config, pkgs, ... }:
{
  # TODO: Different palette support
  # TODO: Write exit codes
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./kometa.omp.toml;
  };
}
