# Neovim Nix Configuration

This repository packages a modular Neovim configuration with
[nix-wrapper-modules](https://birdeehub.github.io/nix-wrapper-modules/wrapperModules/neovim.html).

## Structure

- `init.lua` is the Neovim entry point.
- `lua/myLuaConf/` contains editor options, keymaps, plugin setup, and LSP setup.
- `lua/nixInfoUtils/` contains the small wrapper metadata helper used by Lua.
- `nix/options.nix` contains wrapper and user-facing options.
- `nix/plugins.nix` contains the plugin inventory and startup/lazy placement.
- `nix/runtime.nix` contains language servers, formatters, linters, and CLI tools.
- `after/` contains runtime overrides and Treesitter queries.

Plugin behavior stays in Lua. Nix only provisions plugins and runtime dependencies,
which keeps the configuration easy to modify without changing package plumbing.

## Commands

Build the package:

```bash
nix build .
```

Check the flake:

```bash
nix flake check
```

The package is available as `.#neovim` and `.#default`.

## Customization

Add or remove plugins in `nix/plugins.nix`. Add language servers, formatters, and
other executables in `nix/runtime.nix`. Configure plugin behavior in the matching
Lua module under `lua/myLuaConf/`.

The colorscheme is exposed as `settings.colorscheme` in `nix/options.nix` and is
read by Lua through the generated `nix-info` plugin.
