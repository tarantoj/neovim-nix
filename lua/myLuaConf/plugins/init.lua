require('tokyonight').setup { style = 'night', light_style = 'storm' }
local nixInfo = require('nixInfoUtils')
local colorschemeName = nixInfo.value('tokyonight', 'settings', 'colorscheme')

vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, 'notify')
if ok then
  notify.setup {
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  }
  vim.notify = notify
  vim.keymap.set('n', '<Esc>', function()
    notify.dismiss { silent = true }
  end, { desc = 'dismiss notify popup and clear hlsearch' })
end

vim.g.loaded_netrwPlugin = 1
require('oil').setup {
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
  columns = {
    'icon',
    'permissions',
    'size',
  },
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-s>'] = 'actions.select_vsplit',
    ['<C-h>'] = 'actions.select_split',
    ['<C-t>'] = 'actions.select_tab',
    ['<C-p>'] = 'actions.preview',
    ['<C-c>'] = 'actions.close',
    ['<C-l>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = 'actions.tcd',
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['g.'] = 'actions.toggle_hidden',
    ['g\\'] = 'actions.toggle_trash',
  },
}
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { noremap = true, desc = 'Open Parent Directory' })
vim.keymap.set('n', '<leader>-', '<cmd>Oil .<CR>', { noremap = true, desc = 'Open nvim root directory' })

require('lze').load {
  { import = 'myLuaConf.plugins.telescope' },
  { import = 'myLuaConf.plugins.treesitter' },
  { import = 'myLuaConf.plugins.completion' },
  { import = 'myLuaConf.plugins.test' },
  { import = 'myLuaConf.plugins.ai' },
  { import = 'myLuaConf.plugins.ui' },
  { import = 'myLuaConf.plugins.git' },
  { import = 'myLuaConf.plugins.mini' },
  { import = 'myLuaConf.plugins.statusline' },
  { import = 'myLuaConf.plugins.utility' },
}
