return {
  {
    'codecompanion.nvim',
    auto_enable = true,
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionActions',
      'CodeCompanionInline',
    },
    keys = {
      { '<leader>a', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle CodeCompanion chat' },
    },
    after = function()
      require('codecompanion').setup {
        adapters = {
          acp = {
            opts = {
              show_presets = false,
            },
            opencode = function()
              return require('codecompanion.adapters').extend('opencode', {})
            end,
          },
        },
        interactions = {
          chat = {
            adapter = 'opencode',
          },
        },
      }
    end,
  },
  {
    'copilot.lua',
    auto_enable = true,
    cmd = 'Copilot',
    after = function()
      require('copilot').setup {}
    end,
  },
}
