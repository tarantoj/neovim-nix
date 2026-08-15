return {
  {
    'todo-comments.nvim',
    auto_enable = true,
    cmd = { 'TodoTelescope', 'TodoTrouble' },
    keys = {
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Search TODO comments' },
      { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'List TODO comments' },
    },
    after = function(_)
      require('todo-comments').setup {}
      vim.wait(1000, function()
        return require('todo-comments.config').loaded
      end)
    end,
  },
  {
    'nvim-ts-autotag',
    auto_enable = true,
    ft = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'xml' },
    after = function(_)
      require('nvim-ts-autotag').setup {}
    end,
  },
  {
    'nvim-bqf',
    auto_enable = true,
    ft = 'qf',
    after = function(_)
      require('bqf').setup {}
    end,
  },
  {
    'markdown-preview.nvim',
    auto_enable = true,
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    ft = 'markdown',
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreview <CR>', mode = { 'n' }, noremap = true, desc = 'markdown preview' },
      {
        '<leader>ms',
        '<cmd>MarkdownPreviewStop <CR>',
        mode = { 'n' },
        noremap = true,
        desc = 'markdown preview stop',
      },
      {
        '<leader>mt',
        '<cmd>MarkdownPreviewToggle <CR>',
        mode = { 'n' },
        noremap = true,
        desc = 'markdown preview toggle',
      },
    },
    before = function(_)
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    'which-key.nvim',
    auto_enable = true,
    event = 'DeferredUIEnter',
    after = function(_)
      require('which-key').setup {}
      require('which-key').add {
        { '<leader><leader>', group = 'buffer commands' },
        { '<leader><leader>_', hidden = true },
        { '<leader>c', group = '[c]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[d]ocument' },
        { '<leader>d_', hidden = true },
        { '<leader>g', group = '[g]it' },
        { '<leader>g_', hidden = true },
        { '<leader>m', group = '[m]arkdown' },
        { '<leader>m_', hidden = true },
        { '<leader>r', group = '[r]ename' },
        { '<leader>r_', hidden = true },
        { '<leader>s', group = '[s]earch' },
        { '<leader>s_', hidden = true },
        { '<leader>t', group = '[t]oggles' },
        { '<leader>t_', hidden = true },
        { '<leader>w', group = '[w]orkspace' },
        { '<leader>w_', hidden = true },
      }
    end,
  },
  {
    'trouble.nvim',
    auto_enable = true,
    cmd = 'Trouble',
    after = function(_)
      require('trouble').setup()
    end,
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ...',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
}
