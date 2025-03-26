local M = {}

-- Configuration options
local config = {
  cmd = { "alidistlint" },
  filetypes = { "sh" },
  settings = {
    -- Add any settings here if needed
  },
}

-- Create namespace for diagnostics
local ns_id = vim.api.nvim_create_namespace("alidistlint")

local function parse_diagnostics(output)
  local diagnostics = {}
  for line in output:gmatch("[^\r\n]+") do
    -- Parse each line of output and create diagnostic entries
    -- This is a basic implementation - you might want to adjust the parsing based on actual output format
    local line_num, col, message = line:match("(%d+):(%d+):(.+)")
    if line_num and col and message then
      table.insert(diagnostics, {
        lnum = tonumber(line_num) - 1, -- Convert to 0-based line numbers
        col = tonumber(col) - 1,       -- Convert to 0-based column numbers
        message = message,
        severity = vim.diagnostic.severity.WARN,
        source = "alidistlint",
      })
    end
  end
  return diagnostics
end

local function is_alidist_file(filename)
  return filename:match("alidist/.*%.sh$") ~= nil
end

local function run_lint(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if not filename or not is_alidist_file(filename) then return end

  local cmd = vim.tbl_flatten({config.cmd, filename})
  local output = vim.fn.system(cmd)
  
  local diagnostics = parse_diagnostics(output)
  vim.diagnostic.set(ns_id, bufnr, diagnostics)
end

-- Function to check if a buffer is an alidist file
function M.is_alidist_buffer(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return is_alidist_file(filename)
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  
  -- Create autocommands to run linting
  vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave", "BufWritePost"}, {
    pattern = "*.sh",
    callback = function(event)
      run_lint(event.buf)
    end,
  })
end

return M 