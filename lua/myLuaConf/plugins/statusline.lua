return {
  {
    'fidget.nvim',
    auto_enable = true,
    event = 'DeferredUIEnter',
    after = function(_)
      require('fidget').setup {}
    end,
  },
}
