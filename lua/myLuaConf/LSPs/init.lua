local nixInfo = require('nixInfoUtils')
if nixInfo.value(false, 'settings', 'lspDebugMode') then
  vim.lsp.log.set_level(vim.log.levels.DEBUG)
end
require('lze').h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixInfo.plugin_path('nvim-lspconfig')
  if not lspcfg then
    local matches = vim.api.nvim_get_runtime_file('pack/*/{start,opt}/nvim-lspconfig', false)
    lspcfg = assert(matches[1], 'nvim-lspconfig not found!')
  end
  local ok, cfg = pcall(dofile, lspcfg .. '/lsp/' .. name .. '.lua')
  if not ok then
    ok, cfg = pcall(dofile, lspcfg .. '/lua/lspconfig/configs/' .. name .. '.lua')
  end
  return (ok and cfg or {}).filetypes or {}
end)
-- file uses lzextras.lsp handler
require('lze').load {
  {
    'nvim-lspconfig',
    auto_enable = true,
    -- the on require handler will be needed here if you want to use the
    -- fallback method of getting filetypes if you don't provide any
    on_require = { 'lspconfig' },
    -- define a function to run over all type(plugin.lsp) == table
    -- when their filetype trigger loads them
    lsp = function(plugin)
      local config = plugin.lsp or {}
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities, true)

      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          require('myLuaConf.LSPs.on_attach')({}, ev.buf)
        end,
      })
      -- vim.lsp.config('*', {
      --   on_attach = require('myLuaConf.LSPs.on_attach'),
      -- })
    end,
  },
  {
    -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
    'lazydev.nvim',
    auto_enable = true,
    cmd = { 'LazyDev' },
    ft = 'lua',
    after = function(_)
      local config_dir = nixInfo.value(vim.fn.stdpath('config'), 'settings', 'config_directory')
      require('lazydev').setup {
        library = {
          { words = { 'vim', 'nixInfo' }, path = config_dir .. '/lua' },
        },
      }
    end,
  },
  {
    -- name of the lsp
    'lua_ls',
    -- provide a table containing filetypes,
    -- and then whatever your functions defined in the function type specs expect.
    -- in our case, it just expects the normal lspconfig setup options,
    -- but with a default on_attach and capabilities
    lsp = {
      -- if you provide the filetypes it doesn't ask lspconfig for the filetypes
      filetypes = { 'lua' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { 'vim' },
            disable = { 'missing-fields' },
          },
          telemetry = { enabled = false },
        },
      },
    },
    -- also these are regular specs and you can use before and after and all the other normal fields
  },
  {
    'gopls',
    -- if you don't provide the filetypes it asks lspconfig for them
    lsp = {},
  },
  { 'roslyn_ls', lsp = {} },
  -- {
  --   'vtsls',
  --   lsp = {
  --     settings = {
  --       complete_function_calls = true,
  --       vtsls = {
  --         enableMoveToFileCodeAction = true,
  --         autoUseWorkspaceTsdk = true,
  --         experimental = {
  --           maxInlayHintLength = 30,
  --           completion = {
  --             enableServerSideFuzzyMatch = true,
  --           },
  --         },
  --       },
  --       typescript = {
  --         updateImportsOnFileMove = { enabled = 'always' },
  --         suggest = {
  --           completeFunctionCalls = true,
  --         },
  --         inlayHints = {
  --           enumMemberValues = { enabled = true },
  --           functionLikeReturnTypes = { enabled = true },
  --           parameterNames = { enabled = 'literals' },
  --           parameterTypes = { enabled = true },
  --           propertyDeclarationTypes = { enabled = true },
  --           variableTypes = { enabled = false },
  --         },
  --       },
  --     },
  --   },
  -- },
  { 'tsgo', lsp = {} },
  { 'tailwindcss', lsp = {} },
  { 'biome', lsp = {} },
  { 'basedpyright', lsp = {} },
  { 'terraformls', lsp = {} },
  { 'tflint', lsp = {} },
  { 'eslint', lsp = {} },
  { 'html', lsp = {} },
  { 'cssls', lsp = {} },
  { 'cspell_ls', lsp = {} },
  {
    'jsonls',
    lsp = {
      settings = {
        json = {
          format = { enable = true },
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    },
  },
  { 'dockerls', lsp = {} },
  { 'docker_compose_language_service', lsp = {} },
  { 'taplo', lsp = {} },
  { 'bashls', lsp = {} },
  {
    'yamlls',
    lsp = {
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          keyOrdering = false,
          format = { enable = true },
          validate = true,
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = '',
          },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    },
  },
  {
    'nixd',
    lsp = {
      filetypes = { 'nix' },
      settings = {
        nixd = {
          -- nixd requires some configuration.
          -- The wrapper info plugin provides the values configured in Nix.
          -- for additional configuration options, refer to:
          -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
          nixpkgs = {
            expr = nixInfo.value(nil, 'info', 'nixdExtras', 'nixpkgs'),
          },
          options = {
            -- If you integrated with your system flake,
            -- you should use inputs.self as the path to your system flake
            -- that way it will ALWAYS work, regardless
            -- of where your config actually was.
            nixos = {
              expr = nixInfo.value(nil, 'info', 'nixdExtras', 'nixos_options'),
            },
            -- If you have your config as a separate flake, inputs.self would be referring to the wrong flake.
            -- You can override the correct one into your package definition on import in your main configuration,
            -- or just put an absolute path to where it usually is and accept the impurity.
            ['home-manager'] = {
              expr = nixInfo.value(nil, 'info', 'nixdExtras', 'home_manager_options'),
            },
          },
          formatting = {
            command = { 'alejandra' },
          },
          diagnostic = {
            suppress = {
              'sema-escaping-with',
            },
          },
        },
      },
    },
  },
  {
    'roslyn-nvim',
    auto_enable = true,
    after = function(_)
      require('roslyn').setup {
        exe = 'Microsoft.CodeAnalysis.LanguageServer',
        config = {
          -- capabilities = require('myLuaConf.LSPs.on_attach').get_capabilities('roslyn'),
          settings = {
            ['csharp|completion'] = {
              ['dotnet_provide_regex_completions'] = true,
              ['dotnet_show_completion_items_from_unimported_namespaces'] = true,
              ['dotnet_show_name_completion_suggestions'] = true,
            },
            ['csharp|highlighting'] = {
              ['dotnet_highlight_related_json_components'] = true,
              ['dotnet_highlight_related_regex_components'] = true,
            },
            -- ['navigation'] = {
            --   ['dotnet_navigate_to_decompiled_sources'] = true,
            -- },
            ['csharp|inlay_hints'] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ['csharp|code_lens'] = { dotnet_enable_tests_code_lens = false },
            ['csharp|background_analysis'] = {
              dotnet_analyzer_diagnostics_scope = 'openFiles',
              dotnet_compiler_diagnostics_scope = 'fullSolution',
            },
          },
        },
      }
    end,
    ft = 'cs',
  },
}
