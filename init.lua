-- init.lua

-- Options
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.showmode = false          -- hide -- INSERT -- etc.
vim.opt.smartcase = true          -- smart case search
vim.opt.smartindent = true        -- smarter auto-indenting
vim.opt.swapfile = false          -- disable swapfile
vim.opt.termguicolors = true      -- enable true colors
vim.opt.timeoutlen = 1000         -- shorter key sequence timeout
vim.opt.undofile = true           -- persistent undo
vim.opt.updatetime = 300          -- faster completion (default is 4000ms)
vim.opt.expandtab = true          -- tabs → spaces
vim.opt.shiftwidth = 2            -- 2 spaces for indent
vim.opt.tabstop = 2               -- 2 spaces per tab
vim.opt.number = false            -- line numbers
vim.opt.signcolumn = "yes"        -- always show sign column
vim.opt.wrap = false              -- no line wrap
vim.opt.scrolloff = 8             -- margin above/below cursor
vim.opt.scroll = 12               -- set scroll amount
vim.opt.sidescrolloff = 8         -- margin left/right of cursor
vim.opt.fillchars = { eob = " " } -- hide ~ on end of buffer
vim.opt.exrc = true               -- allows local cfgs

-- Requires
require("config.lazy")
require("config.keymaps")
require("config.user_functions")

-- enable nvim notify
vim.notify = require("notify")
