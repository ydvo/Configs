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

return M
