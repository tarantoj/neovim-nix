return {
  {
    'persistence.nvim',
    auto_enable = true,
    event = 'BufReadPre',
    keys = {
      { '<leader>qs', '<cmd> lua require("persistence").load()<cr>', desc = 'Restore session' },
      { '<leader>ql', '<cmd> lua require("persistence").load { last = true }<cr>', desc = 'Restore last session' },
      { '<leader>qd', '<cmd> lua require("persistence").stop()<cr>', desc = 'Stop session persistence' },
    },
    after = function(_)
      require('persistence').setup()
    end,
  },
  {
    'nvim-autopairs',
    auto_enable = true,
    event = 'InsertEnter',
    after = function(_)
      require('nvim-autopairs').setup()
    end,
  },
  {
    'undotree',
    auto_enable = true,
    cmd = { 'UndotreeToggle', 'UndotreeHide', 'UndotreeShow', 'UndotreeFocus', 'UndotreePersistUndo' },
    keys = { { '<leader>U', '<cmd>UndotreeToggle<CR>', mode = { 'n' }, desc = 'Undo Tree' } },
    before = function(_)
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
    end,
  },
  {
    'vim-startuptime',
    auto_enable = true,
    cmd = { 'StartupTime' },
    before = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
    end,
  },
  {
    'neogen',
    auto_enable = true,
    keys = { { '<leader>ng', ":lua require('neogen').generate()<CR>", mode = { 'n' }, desc = '[N]eo[G]enerate' } },
    after = function(_)
      require('neogen').setup {
        snippet_engine = 'luasnip',
        languages = {
          cs = { template = { annotation_convention = 'xmldoc' } },
        },
      }
    end,
  },
}
