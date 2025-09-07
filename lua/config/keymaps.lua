-- Keymaps
local set = vim.keymap.set

-- Execute
set("n", "<space><space>x", "<cmd>source %<CR>")
set("n", "<space>x", ":.lua<CR>")
set("v", "<space>x", ":lua<CR>")

-- Fzf
set("n", "<leader>ff", require('fzf-lua').files, { desc = "Fzf Files" })
set("n", "<leader>fg", require('fzf-lua').live_grep, { desc = "Live grep" })
set("n", "<leader>fb", require('fzf-lua').buffers, { desc = "Search Buffers" })
set("n", "<leader>fm", require('fzf-lua').marks, { desc = "Search marks" })
set("n", "<leader>fh", require('fzf-lua').helptags, { desc = "Search help" })

-- Diagnostic
set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")

-- LSP
set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

-- Oil
set("n", "-", "<cmd>Oil<CR>")

-- -- sc-im
-- set('n', '<leader>sc', ":lua require'sc-im'.open_in_scim()<CR>", { desc = "Open sc-im", noremap = true, silent = true })

-- Terminal
local terminal_bufnr = nil

set("n", "~~", function()
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
end)

-- Terminal mode mapping: leave terminal or hide it (optional)
set("t", "~~", "<C-\\><C-n>:hide<CR>")

-- Auto-close pairs with space after opening in insert mode
local function autopair(open, close)
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

-- Set mappings
vim.keymap.set("i", "(", autopair("(", ")"), { expr = true })
vim.keymap.set("i", "[", autopair("[", "]"), { expr = true })
vim.keymap.set("i", "{", autopair("{", "}"), { expr = true })
vim.keymap.set("i", "\"", autopair("\"", "\""), { expr = true })
vim.keymap.set("i", "'", autopair("'", "'"), { expr = true })
