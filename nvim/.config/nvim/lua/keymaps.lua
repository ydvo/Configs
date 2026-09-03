-- Keymaps
local userfunctions = require("user_functions")

local set = vim.keymap.set

-- Leader
vim.g.mapleader = " "

-- Execute
set("n", "<space><space>x", "<cmd>source %<CR>")
set("n", "<space>x", ":.lua<CR>")
set("v", "<space>x", ":lua<CR>")

-- Buffer
set("n", "<leader>bd", "<cmd>bprevious <bar> bdelete #<CR>", { desc = "Delete buffer" })

-- Fzf
vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = "Search Buffers" })
vim.keymap.set("n", "<leader>fm", "<cmd>lua require('fzf-lua').marks()<CR>", { desc = "Search marks" })
vim.keymap.set("n", "<leader>fh", "<cmd>lua require('fzf-lua').helptags()<CR>", { desc = "Search help" })
vim.keymap.set("n", "<leader>fs", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>",
  { desc = "Search LSP symbols" })
vim.keymap.set("n", "<leader>fd", "<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>",
  { desc = "Search LSP diagnostics" })

-- Diagnostic
set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
set("n", "<leader>d", vim.diagnostic.setqflist, { desc = "Add buffer diagnostics to quickfix list" })

-- LSP
set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename variable" })
set("n", "<leader>h", "<cmd>LspClangdSwitchSourceHeader<CR>")

-- Oil
set("n", "-", "<cmd>Oil<CR>")

-- Neogen
set("n", "<leader>D", "<cmd>lua require('neogen').generate()<CR>", { desc = "Generate function documentation" })

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

-- Briefly Show Line Numbers
set('n', '<leader>n', '', {
  noremap = true,
  silent = true,
  desc = "Show Line Numbers",
  callback = function()
    -- vim.wo.number = true
    vim.wo.relativenumber = true

    -- Create an autocmd that disables numbers on the next cursor move
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      once = true, -- trigger only once
      callback = function()
        -- vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })
  end,
})

local numbers_on = false
-- Toggle relative line numbers
set('n', '<leader>N', '', {
  noremap = true,
  silent = true,
  desc = "Toggle line numbers",
  callback = function()
    if numbers_on then
      numbers_on = false
      vim.wo.relativenumber = false
    else
      numbers_on = true
      vim.wo.relativenumber = true
    end
  end,
})

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
    set("i", "|", userfunctions.autopair_quotes("|"), { expr = true })
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
