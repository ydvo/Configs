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
