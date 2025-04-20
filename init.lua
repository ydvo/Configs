-- init.lua

-- Keymaps
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Options
vim.opt.clipboard = "unnamedplus"               -- use system clipboard
vim.opt.pumheight = 10                          -- pop-up menu height
vim.opt.showmode = false                        -- hide -- INSERT -- etc.
vim.opt.showtabline = 2                         -- always show tabline
vim.opt.smartcase = true                        -- smart case search
vim.opt.smartindent = true                      -- smarter auto-indenting
vim.opt.splitbelow = true                       -- horizontal splits below
vim.opt.splitright = true                       -- vertical splits right
vim.opt.swapfile = false                        -- disable swapfile
vim.opt.termguicolors = true                    -- enable true colors
vim.opt.timeoutlen = 1000                       -- shorter key sequence timeout
vim.opt.undofile = true                         -- persistent undo
vim.opt.updatetime = 300                        -- faster completion (default is 4000ms)
vim.opt.expandtab = true                        -- tabs → spaces
vim.opt.shiftwidth = 2                          -- 2 spaces for indent
vim.opt.tabstop = 2                             -- 2 spaces per tab
vim.opt.cursorline = true                       -- highlight current line
vim.opt.number = true                           -- line numbers
vim.opt.signcolumn = "yes"                      -- always show sign column
vim.opt.wrap = false                            -- no line wrap
vim.opt.scrolloff = 8                           -- margin above/below cursor
vim.opt.sidescrolloff = 8                       -- margin left/right of cursor

-- Requires
require("config.lazy")
