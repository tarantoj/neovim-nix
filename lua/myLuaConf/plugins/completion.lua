local load_w_after = function(name)
  vim.cmd.packadd(name)
  vim.cmd.packadd(name .. '/after')
end

return {
  {
    'cmp-cmdline',
    auto_enable = true,
    on_plugin = { 'blink.cmp' },
    load = load_w_after,
  },
  {
    'blink.compat',
    auto_enable = true,
    dep_of = { 'cmp-cmdline' },
  },
  {
    'friendly-snippets',
    auto_enable = true,
    dep_of = { 'blink.cmp' },
  },
  {
    'luasnip',
    auto_enable = true,
    dep_of = { 'blink.cmp' },
    after = function(_)
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local ls = require('luasnip')

      vim.keymap.set({ 'i', 's' }, '<M-n>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
    end,
  },
  {
    'colorful-menu.nvim',
    auto_enable = true,
    on_plugin = { 'blink.cmp' },
  },
  {
    'blink-cmp-git',
    auto_enable = true,
    on_plugin = { 'blink.cmp' },
  },
  {
    'blink.cmp',
    auto_enable = true,
    event = 'DeferredUIEnter',
    dep_of = 'nvim-lspconfig',
    after = function(_)
      require('blink.cmp').setup {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- See :h blink-cmp-config-keymap for configuring keymaps
        keymap = {
          preset = 'default',
        },
        cmdline = {
          enabled = true,
          completion = {
            menu = {
              auto_show = true,
            },
          },
          sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == '/' or type == '?' then
              return { 'buffer' }
            end
            -- Commands
            if type == ':' or type == '@' then
              return { 'cmdline', 'cmp_cmdline' }
            end
            return {}
          end,
        },
        fuzzy = {
          sorts = {
            'exact',
            -- defaults
            'score',
            'sort_text',
          },
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },
        completion = {
          menu = {
            draw = {
              treesitter = { 'lsp' },
              components = {
                label = {
                  text = function(ctx)
                    return require('colorful-menu').blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require('colorful-menu').blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
          },
        },
        snippets = {
          preset = 'luasnip',
          active = function(_)
            local snippet = require('luasnip')
            local blink = require('blink.cmp')
            if snippet.in_snippet() and not blink.is_visible() then
              return true
            else
              if not snippet.in_snippet() and vim.fn.mode() == 'n' then
                snippet.unlink_current()
              end
              return false
            end
          end,
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'git' },
          providers = {
            path = {
              score_offset = 50,
            },
            lsp = {
              score_offset = 40,
            },
            snippets = {
              score_offset = 40,
            },
            git = {
              module = 'blink-cmp-git',
              name = 'Git',
              opts = {
                -- options for the blink-cmp-git
              },
            },
            cmp_cmdline = {
              name = 'cmp_cmdline',
              module = 'blink.compat.source',
              score_offset = -100,
              opts = {
                cmp_name = 'cmdline',
              },
            },
          },
        },
      }
    end,
  },
}
