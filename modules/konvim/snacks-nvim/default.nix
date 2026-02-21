{ inputs, ... }:
{
  enable = true;
  setupOpts = {
    dashboard = import ./dashboard { inherit inputs; };
  };
}
