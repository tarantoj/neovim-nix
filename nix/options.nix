{
  config,
  lib,
  pkgs,
  ...
}: {
  options.settings.colorscheme = lib.mkOption {
    type = lib.types.enum ["tokyonight"];
    default = "tokyonight";
    description = "Colorscheme selected by the Lua configuration.";
  };

  config = {
    settings.config_directory = ../.;
    settings.colorscheme = "tokyonight";
    settings.block_normal_config = true;

    info.nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
    info.nixdExtras.nixos_options = null;
    info.nixdExtras.home_manager_options = null;
  };
}
