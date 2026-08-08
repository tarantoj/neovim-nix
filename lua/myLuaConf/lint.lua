require('lze').load {
  {
    'nvim-lint',
    auto_enable = true,
    -- cmd = { "" },
    event = 'FileType',
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    after = function(_)
      require('lint').linters_by_ft = {
        -- Add linters to nix/runtime.nix before configuring them here.
        -- and configure them here
        -- markdown = {'vale',},
        -- javascript = { 'eslint' },
        -- typescript = { 'eslint' },
        -- javascriptreact = { 'eslint' },
        -- typescriptreact = { 'eslint' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
