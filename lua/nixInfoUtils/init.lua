local M = {}

M.isNix = vim.g.nix_info_plugin_name ~= nil
local info = M.isNix and require(vim.g.nix_info_plugin_name) or nil

function M.value(default, ...)
  if info == nil then
    return default
  end
  return info(default, ...)
end

function M.plugin_path(name)
  return M.value(nil, 'plugins', 'lazy', name) or M.value(nil, 'plugins', 'start', name)
end

return M
