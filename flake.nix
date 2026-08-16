{
  description = "Configured Neovim package built with nix-wrapper-modules";
  inputs.devenv.url = "github:cachix/devenv";
  inputs.devenv.inputs.nixpkgs.follows = "nixpkgs";
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
  inputs.llm-agents.url = "github:numtide/llm-agents.nix";
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };
  outputs = {
    self,
    nixpkgs,
    wrappers,
    devenv,
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
      pkgs = (nixpkgs.legacyPackages.${system}).extend inputs.llm-agents.overlays.shared-nixpkgs;
      neovim = self.packages.${system}.neovim;
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({
            pkgs,
            config,
            ...
          }: {
            opencode.enable = true;
            opencode.rules = ./AGENTS.md;
            opencode.commands = {
              test = ''
                ---description: Run the full test suite via git-hooks
                Run `devenv test` (runs alejandra + stylua git-hooks on all files) and report any failures.

                ```bash
                devenv test
                ```
              '';
              build = ''
                ---description: Build the Neovim package
                Build the flake package with `nix build .` and report any errors.

                ```bash
                nix build .
                ```
              '';
              smoke = ''
                ---description: Run the headless Neovim startup smoke test
                Start the packaged Neovim headless and quit immediately to verify it loads without errors.

                ```bash
                nix develop --impure --command nvim --headless -c 'qa!'
                ```
              '';
              fmt = ''
                ---description: Format Nix and Lua files
                Format all Nix files with `nix fmt` and Lua files with stylua, then report what changed.

                ```bash
                nix fmt .
                stylua init.lua lua after
                ```
              '';
            };
            opencode.agents = {
              reviewer = ''
                ---description: Reviews Nix and Lua code for quality, correctness, and project conventions
                mode: subagent
                permission:
                  edit: deny
                  bash: deny
                ---
                You are an expert code reviewer for this Neovim config repo.
                Focus on:
                - Nix: module structure, plugin inventory consistency (nix/plugins.nix vs lua specs), runtime deps
                - Lua: `lze` spec correctness, lazy-loading triggers, adherence to project conventions
                - Whether new plugins are wired in BOTH nix/plugins.nix and the matching lua spec
                - Formatting consistency (alejandra, stylua)
                Provide constructive, specific feedback without making changes.
              '';
              lua-expert = ''
                ---description: Writes and debugs Neovim Lua plugin configuration
                mode: subagent
                permission:
                  bash: deny
                ---
                You are a Neovim Lua configuration specialist.
                When writing or editing `lze` plugin specs in lua/myLuaConf/plugins/*.lua:
                - Set the spec name to the pack directory name (e.g. 'mini.nvim'), NOT the nixpkgs attr
                - Use appropriate triggers (cmd/keys/ft/event/on_require/dep_of) for lazy loading
                - Follow existing patterns in neighboring plugin files
                - Keep style consistent with stylua formatting
              '';
            };
            opencode.mcp = {
              devenv = {
                type = "local";
                command = [
                  "devenv"
                  "mcp"
                ];
                environment = {
                  DEVENV_ROOT = "{env:DEVENV_ROOT}";
                };
              };
            };
            git-hooks.hooks = {
              alejandra.enable = true;
              alejandra.settings.check = true;
              stylua = {
                enable = true;
                name = "stylua";
                entry = "stylua --check";
                files = "\\.lua$";
              };
            };
            packages = with pkgs;
              [
                alejandra
                stylua
                luajit
                lua-language-server
                nixd
                llm-agents.opencode
              ]
              ++ [neovim];
          })
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
