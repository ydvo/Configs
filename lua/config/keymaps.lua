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

-- Terminal
set("n", "~~", function()
  vim.cmd.new()
  vim.cmd.term()
  vim.api.nvim_win_set_height(0, 15)
end)

-- Diagnostic
set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")

-- LSP
set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

-- Oil
set("n", "-", "<cmd>Oil<CR>")
