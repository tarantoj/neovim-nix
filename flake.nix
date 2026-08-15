{
  description = "Configured Neovim package built with nix-wrapper-modules";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  inputs.wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
  inputs.wrappers.inputs.nixpkgs.follows = "nixpkgs";
  # Keep these plugins independent from the nixpkgs update cycle.
  inputs.plugins-lze = {
    url = "github:BirdeeHub/lze";
    flake = false;
  };
  # These 2 are already in nixpkgs, however this ensures you always fetch the most up to date version!
  inputs.plugins-lzextras = {
    url = "github:BirdeeHub/lzextras";
    flake = false;
  };
  inputs.plugins-fugitive-azure-devops = {
    url = "github:cedarbaum/fugitive-azure-devops.vim";
    flake = false;
  };
  outputs = {
    self,
    nixpkgs,
    wrappers,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    module = nixpkgs.lib.modules.importApply ./module.nix inputs;
    wrapper = wrappers.lib.evalModule module;
  in {
    overlays = {
      neovim = final: prev: {neovim = wrapper.config.wrap {pkgs = final;};};
      default = self.overlays.neovim;
    };
    wrapperModules = {
      neovim = module;
      default = self.wrapperModules.neovim;
    };
    wrappers = {
      neovim = wrapper.config;
      default = self.wrappers.neovim;
    };
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        neovim = wrapper.config.wrap {inherit pkgs;};
        default = self.packages.${system}.neovim;
      }
    );
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          stylua
          luajit
          lua-language-server
          nixd
          self.packages.${system}.neovim
        ];
      };
    });
    # `wrappers.neovim.enable = true`
    nixosModules = {
      default = self.nixosModules.neovim;
      neovim = wrappers.lib.getInstallModule {
        name = "neovim";
        value = module;
      };
    };
    # `wrappers.neovim.enable = true`
    # You can set any of the options.
    # But that is how you enable it.
    homeModules = {
      default = self.homeModules.neovim;
      neovim = wrappers.lib.getInstallModule {
        name = "neovim";
        value = module;
      };
    };
  };
}
