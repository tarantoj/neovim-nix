-- NOTE: various, non-plugin config
require('myLuaConf.opts_and_keys')

local nixInfo = require('nixInfoUtils')

-- Disable optional plugin specs when their Nix package is unavailable.
require('lze').register_handlers {
  {
    spec_field = 'auto_enable',
    set_lazy = false,
    modify = function(plugin)
      if not nixInfo.isNix then
        return plugin
      end

      if type(plugin.auto_enable) == 'table' then
        for _, name in pairs(plugin.auto_enable) do
          if not nixInfo.plugin_path(name) then
            plugin.enabled = false
            break
          end
        end
      elseif type(plugin.auto_enable) == 'string' then
        if not nixInfo.plugin_path(plugin.auto_enable) then
          plugin.enabled = false
        end
      elseif plugin.auto_enable == true and not nixInfo.plugin_path(plugin.name) then
        plugin.enabled = false
      end

      return plugin
    end,
  },
  -- Register the LSP handler from lzextras.
  require('lzextras').lsp,
}

-- you can set up lsps within lze specs,
-- and trigger lspconfig setup hooks only on the correct filetypes
-- demonstrated in ./LSPs/init.lua

-- NOTE: general plugins
require('myLuaConf.plugins')

-- NOTE: obviously, more plugins, but more organized by what they do below

require('myLuaConf.LSPs')

require('myLuaConf.debug')
require('myLuaConf.lint')
require('myLuaConf.format')
