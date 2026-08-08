return {
  {
    'lualine.nvim',
    auto_enable = true,
    event = 'DeferredUIEnter',
    after = function(_)
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
              status = true,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              'filename',
              path = 3,
              status = true,
            },
          },
          lualine_x = { 'filetype' },
        },
        tabline = {
          lualine_a = { 'buffers' },
          lualine_z = { 'tabs' },
        },
      }
    end,
  },
  {
    'fidget.nvim',
    auto_enable = true,
    event = 'DeferredUIEnter',
    after = function(_)
      require('fidget').setup {}
    end,
  },
}
