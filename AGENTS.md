# AGENTS.md

Nix-flake-packaged Neovim config using [nix-wrapper-modules](https://birdeehub.github.io/nix-wrapper-modules/wrapperModules/neovim.html) + the `lze` lazy loader. Plugin behavior lives in Lua; Nix only provisions plugins and runtime deps.

## Architecture

- `module.nix` imports `nix/options.nix` (user-facing settings, nixd extras), `nix/plugins.nix` (plugin inventory + startup list), `nix/runtime.nix` (`runtimePkgs`: LSP servers, formatters, linters, CLIs).
- `lua/myLuaConf/init.lua` wires everything: registers `lze` handlers, loads plugins via `lze.load { { import = 'myLuaConf.plugins.X' }, ... }`.
- `lua/myLuaConf/plugins/*.lua` are `lze` specs (triggers: `cmd`/`keys`/`ft`/`event`/`on_require`/`dep_of`; hooks: `before`/`after`). One file per feature area (ui, git, telescope, ai, test, completion, statusline, mini, utility, treesitter).
- `lua/nixInfoUtils/init.lua` is the Nix→Lua bridge: reads values set in `nix/options.nix` (e.g. `settings.colorscheme`, `settings.config_directory`) through the generated `nix-info` plugin. Falls back to defaults when run outside Nix.
- `nix/plugins.nix` `startup` list = auto-loaded at startup; `plugins.lazy.data` = lazy (opt) plugins. `vimPlugins` attr names differ from pack dir names.

## Adding a plugin requires BOTH

1. `nix/plugins.nix` `plugins.lazy.data` (or `startup`): `vimPlugins.<name>` or an external `plugins-<name>` flake input (see `pluginsFromPrefix`).
2. A `lze` spec in the matching `lua/myLuaConf/plugins/*.lua` with the spec name set to the **pack directory name** (e.g. `'mini.nvim'`, `'telescope.nvim'`), NOT the nixpkgs attr (`mini-nvim`). A mismatched name silently fails to load (`packadd` fails, no error at startup).

Runtime deps (linters/formatters/LSP servers) must be added to `nix/runtime.nix` before configuring them in Lua (see comment in `lua/myLuaConf/lint.lua`). LSP servers are declared in `lua/myLuaConf/LSPs/init.lua` specs.

## Verification (also what CI runs)

```bash
nix flake check
nix build .
nix fmt -- --check .                       # nix formatting (uses flake formatter)
nix develop --command stylua --check init.lua lua after   # lua formatting
nix develop --command nvim --headless -c 'qa!'  # startup smoke test
```

CI (`.github/workflows/ci.yml`) runs all of the above on ubuntu-latest + macos-latest for every push/PR. The devshell (`nix develop` / `.envrc` via direnv) provides alejandra, stylua, luajit, lua-language-server, nixd, and neovim.

## Gotchas

- **The packaged config only includes git-tracked files.** `settings.config_directory = ../.` copies the git index, not the working tree. New files (e.g. a new `plugins/*.lua`) are silently absent from `nix build`/`nix run` output until `git add`-ed. Staging (not committing) is enough.
- `nix build .` creates an untracked `result` symlink in the repo root; remove it before finishing.
- Plugins with `event = 'DeferredUIEnter'` (gitsigns, which-key, fidget, etc.) won't load at startup in a headless run — expected, not a regression.
- In this session the CI format checks only pass if `nix fmt`/`stylua` are clean, so run them before pushing.
