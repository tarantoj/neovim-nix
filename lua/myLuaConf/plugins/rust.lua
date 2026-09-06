return {
  {
    -- rustaceanvim sets up the rust-analyzer client itself (ftplugin-based,
    -- lazy by design). Do NOT also add `rust_analyzer` to lua/myLuaConf/LSPs/init.lua
    -- as a lspconfig spec -- that conflicts with rustaceanvim's own client.
    'rustaceanvim',
    auto_enable = true,
    after = function(_)
      -- vim.g.rustaceanvim may be a function, evaluated when the client
      -- configures rust-analyzer (on opening a rust file). That defers the
      -- blink.cmp require until blink is actually loaded, mirroring how the
      -- lspconfig handler in lua/myLuaConf/LSPs/init.lua resolves capabilities.
      vim.g.rustaceanvim = function()
        local blink = require('blink.cmp')
        return {
          server = {
            capabilities = blink.get_lsp_capabilities(),
            default_settings = {
              ['rust-analyzer'] = {
                check = {
                  command = 'clippy',
                  allTargets = true,
                  extraArgs = { '--no-deps' },
                },
                cargo = {
                  allFeatures = true,
                  buildScripts = { enable = true },
                },
                procMacro = { enable = true },
              },
            },
          },
        }
      end
    end,
  },
  {
    'crates.nvim',
    event = { 'BufRead Cargo.toml', 'BufRead Cargo.lock' },
    after = function(_)
      require('crates').setup()
    end,
  },
}
