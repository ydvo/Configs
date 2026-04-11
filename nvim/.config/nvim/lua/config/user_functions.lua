-- user_functions.lua
--    collection of user defined functions
local M = {}
local terminal_bufnr = nil

-- Function to toggle terminal window
function M.terminal_toggle()
  return function()
    if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
      -- If terminal already exists, go to it
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
          vim.api.nvim_set_current_win(win)
          vim.cmd.startinsert()
          return
        end
      end
      -- Terminal buffer exists but not visible, open it in split
      vim.cmd.new()
      vim.api.nvim_win_set_buf(0, terminal_bufnr)
      vim.api.nvim_win_set_height(0, 15)
      vim.cmd.startinsert()
    else
      -- Terminal doesn't exist, create it
      vim.cmd.new()
      vim.cmd.term()
      vim.api.nvim_win_set_height(0, 15)
      vim.cmd.startinsert()
      terminal_bufnr = vim.api.nvim_get_current_buf()
    end
  end
end

-- Auto-close pairs with space after opening in insert mode
function M.autopair(open, close)
  return function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    -- Check if cursor is at end or followed by whitespace
    if col > #line or line:sub(col, col):match("%s") then
      return open .. close .. "<Left>"
    else
      return open
    end
  end
end

-- Overtyping closers
function M.overtype(char)
  return function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    if line:sub(col, col) == char then
      return "<Right>" -- move past existing closer
    else
      return char      -- insert it normally
    end
  end
end

-- Auto-close quotes with space after opening in insert mode
--    and overtypes closing quotes
function M.autopair_quotes(char)
  return function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    -- Check if cursor is at end or followed by whitespace
    if col > #line or line:sub(col, col):match("%s") then
      return char .. char .. "<Left>"
    elseif line:sub(col, col) == char then
      return "<Right>" -- move past closer
    else
      return char
    end
  end
end

-- Run Typst watch and open zathura
function M.typstwatch()
  return function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r") .. ".pdf"

    -- start typst watch
    vim.fn.jobstart({ "typst", "watch", file, out })
    -- Open zathura
    vim.fn.jobstart({ "zathura", out })
  end
end

-- Toggle Writing Mode
local writing_mode = {
  enabled = false,
  background = nil,
  colorscheme = nil,
}

function ToggleWritingMode()
  if not writing_mode.enabled then
    -- Save state
    writing_mode.background = vim.o.background
    writing_mode.colorscheme = vim.g.colors_name

    -- Enable writing mode
    vim.o.background = "light"
    vim.cmd("colorscheme koda")

    -- vim.cmd("ZenMode")
    vim.cmd("PencilSoft")

    writing_mode.enabled = true
  else
    -- Restore state
    -- vim.cmd("ZenMode")
    vim.cmd("PencilOff")

    if writing_mode.background then
      vim.o.background = writing_mode.background
    end

    if writing_mode.colorscheme then
      vim.cmd("colorscheme " .. writing_mode.colorscheme)
    end

    writing_mode.enabled = false
  end
end

-- Create callable command
vim.api.nvim_create_user_command("WriteMode", ToggleWritingMode, {})

-- AutoCommands
-- Auto Format on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Check for tinymist
    if client.name == "tinymist" then
      -- Force-enable formatting capability
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end

    -- ensure lsp supports formatting
    if client:supports_method('textDocument/formatting') then
      -- create group to prevent duplicates
      local group = vim.api.nvim_create_augroup(
        "LspFormat_" .. args.buf,
        { clear = true }
      )

      -- Auto-format ("lint") on save.
      -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = group,
        buffer = args.buf,
        callback = function()
          print("Formating...")
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- -- Adjust colorscheme
vim.api.nvim_create_autocmd('Colorscheme', {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  end,
})

return M
