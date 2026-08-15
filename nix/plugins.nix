{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs) vimPlugins;
  externalPlugins = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
in {
  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    type = pkgs.lib.types.raw;
    readOnly = true;
    default = prefix: sourceInputs:
      pkgs.lib.pipe sourceInputs [
        builtins.attrNames
        (builtins.filter (name: pkgs.lib.hasPrefix prefix name))
        (map (input: let
          name = pkgs.lib.removePrefix prefix input;
        in {
          inherit name;
          value = config.nvim-lib.mkPlugin name sourceInputs.${input};
        }))
        builtins.listToAttrs
      ];
  };

  config.specs = {
    startup = [
      vimPlugins.lze
      vimPlugins.lzextras
      vimPlugins.vim-repeat
      vimPlugins.vim-sleuth
      vimPlugins.plenary-nvim
      vimPlugins.nvim-notify
      vimPlugins.oil-nvim
      vimPlugins.trouble-nvim
      vimPlugins.SchemaStore-nvim
    ];

    colorscheme = vimPlugins.tokyonight-nvim;

    plugins = {
      lazy = true;
      data = [
        vimPlugins.nvim-lspconfig
        vimPlugins.persistence-nvim
        vimPlugins.todo-comments-nvim
        vimPlugins.diffview-nvim
        vimPlugins.nvim-ts-autotag
        vimPlugins.nvim-bqf
        vimPlugins.vim-startuptime
        vimPlugins.blink-cmp
        vimPlugins.blink-compat
        vimPlugins.cmp-cmdline
        vimPlugins.colorful-menu-nvim
        vimPlugins.fidget-nvim
        vimPlugins.gitsigns-nvim
        vimPlugins.which-key-nvim
        vimPlugins.nvim-lint
        vimPlugins.conform-nvim
        vimPlugins.nvim-treesitter-textobjects
        vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.lazydev-nvim
        vimPlugins.markdown-preview-nvim
        vimPlugins.undotree
        vimPlugins.neogen
        vimPlugins.neotest
        vimPlugins.neotest-vitest
        vimPlugins.neotest-jest
        vimPlugins.avante-nvim
        vimPlugins.copilot-lua
        vimPlugins.img-clip-nvim
        vimPlugins.render-markdown-nvim
        vimPlugins.dressing-nvim
        vimPlugins.nui-nvim
        vimPlugins.telescope-nvim
        vimPlugins.telescope-fzf-native-nvim
        vimPlugins.telescope-ui-select-nvim
        vimPlugins.luasnip
        vimPlugins.friendly-snippets
        vimPlugins.blink-cmp-git
        vimPlugins.mini-nvim
        vimPlugins.nvim-dap
        vimPlugins.nvim-dap-ui
        vimPlugins.nvim-dap-virtual-text
        vimPlugins.nvim-dap-go
        vimPlugins.vim-fugitive
        vimPlugins.vim-rhubarb
        externalPlugins.fugitive-azure-devops
        vimPlugins.roslyn-nvim
      ];
    };
  };
}
