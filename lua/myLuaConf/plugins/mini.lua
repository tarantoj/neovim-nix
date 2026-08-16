return {
  {
    'mini.nvim',
    auto_enable = true,
    lazy = false,
    after = function(_)
      require('mini.starter').setup()
      require('mini.trailspace').setup()
      require('mini.hipatterns').setup()

      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      local statusline = require('mini.statusline')
      statusline.setup { use_icons = true }
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end

      require('mini.tabline').setup { show_icons = true, tabpage_section = 'right' }

      require('mini.cursorword').setup { delay = 100 }
      require('mini.move').setup()
      require('mini.ai').setup {}
      require('mini.bracketed').setup {}
      require('mini.bufremove').setup {}
      require('mini.misc').setup_restore_cursor()

      -- Treesitter-aware commentstring is handled natively by mini.comment.
      require('mini.comment').setup {}
      require('mini.indentscope').setup()
      require('mini.surround').setup()
      require('mini.pairs').setup()
    end,
  },
}
