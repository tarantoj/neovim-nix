return {
  {
    'avante.nvim',
    auto_enable = true,
    cmd = {
      'AvanteAsk',
      'AvanteChat',
      'AvanteEdit',
      'AvanteFocus',
      'AvanteSwitchProvider',
      'AvanteShowRepoMap',
      'AvanteToggle',
    },
    after = function()
      require('avante').setup { provider = 'copilot' }
    end,
  },
  {
    'copilot.lua',
    auto_enable = true,
    cmd = 'Copilot',
    after = function()
      require('copilot').setup {}
    end,
    dep_of = 'avante.nvim',
  },
  { 'img-clip.nvim', auto_enable = true, dep_of = 'avante.nvim' },
  {
    'render-markdown-nvim',
    auto_enable = true,
    dep_of = 'avante.nvim',
  },
  { 'dressing-nvim', auto_enable = true, dep_of = 'avante.nvim' },
  { 'nui.nvim', auto_enable = true, dep_of = 'avante.nvim' },
}
