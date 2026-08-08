inputs: {wlib, ...}: {
  _module.args.inputs = inputs;

  imports = [
    wlib.wrapperModules.neovim
    ./nix/options.nix
    ./nix/plugins.nix
    ./nix/runtime.nix
  ];
}
