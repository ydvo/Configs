-- Keymaps
local userfunctions = require("config.user_functions")

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
set("n", "~~", userfunctions.terminal_toggle())

-- Terminal mode mapping: leave terminal or hide it
set("t", "~~", "<C-\\><C-n>:hide<CR>")


-- Set mappings
set("i", "(", userfunctions.autopair("(", ")"), { expr = true })
set("i", "[", userfunctions.autopair("[", "]"), { expr = true })
set("i", "{", userfunctions.autopair("{", "}"), { expr = true })

set("i", ")", userfunctions.overtype(")"), { expr = true })
set("i", "]", userfunctions.overtype("]"), { expr = true })
set("i", "}", userfunctions.overtype("}"), { expr = true })
set("i", ">", userfunctions.overtype(">"), { expr = true })

set("i", "\"", userfunctions.autopair_quotes("\""), { expr = true })

-- File specific keybings
-- Rust
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    -- Build
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>b", ":make build<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>B", ":make run<CR>", { noremap = true, silent = true })
  end
})

-- Typst
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function()
    -- Watch
    set("n", "<leader>t", userfunctions.typstwatch(), { noremap = true, silent = true })
    -- $ autopair
    set("i", "$", userfunctions.autopair_quotes("$"), { expr = true })
  end
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Run
    set("n", "<leader>b", ":!python3 %<CR>", { noremap = true, silent = true })
  end
})
