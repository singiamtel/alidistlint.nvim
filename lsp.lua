local util = require('lspconfig.util')
local server = require('alidistlint.server')

local M = {}

M.config = {
  cmd = { "alidistlint" },
  filetypes = { "yaml" },
  root_dir = function(fname)
    return util.root_pattern("alidist")(fname) or
           util.root_pattern(".git")(fname) or
           vim.fn.getcwd()
  end,
  settings = {},
  on_new_config = function(new_config, new_root_dir)
    -- Add any additional configuration here
  end,
}

M.docs = {
  description = [[
https://github.com/alisw/alidistlint
LSP integration for alidistlint
]],
  default_config = M.config,
}

function M.setup(config)
  local lspconfig = require('lspconfig')
  lspconfig.alidistlint = {
    default_config = M.config,
    docs = M.docs,
    on_new_config = M.config.on_new_config,
  }
  lspconfig.alidistlint.setup(config)
end

return M 