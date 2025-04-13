local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- File Navigation
-- keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Oil
keymap("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":Bdelete<CR>", opts)

-- Clear search higlighting
keymap("n", "<leader>/", ":noh<cr>", { noremap = true, silent = true, desc = "Clear search highlighting" }
)

--Makefile
keymap("n", "M", ":make<CR>", opts)
keymap("n", "MF", ":make flash<CR>", opts)
keymap("n", "MC", ":make clean<CR>", opts)

-- Spell
keymap("n", "<leader>ss", "i<C-X>s<C-n><Enter><ESC>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("t", "<ESC>", "<C-\\><C-N>", term_opts)

-- Telescope --
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", { noremap = true, silent = true, desc = "Find file" }
)
keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", { noremap = true, silent = true, desc = "Find buffer" }
)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true, desc = "Live Grep" }
)

-- Matlab --
keymap("n", "<C-m>", "<cmd>MatlabCliRunCell<CR>", term_opts)

-- Terminal --

-- Write as sudo --
keymap('c', 'w!!', "<esc>:lua require'user.utils'.sudo_write()<CR>", { silent = true })

-- Vimspector Debug --
keymap("n", "<leader>dd", "<cmd>call vimspector#Launch()<CR>", opts)
keymap("n", "<leader>de", "<cmd>call vimspector#Reset()<CR>", opts)
keymap("n", "<leader>dc", "<cmd>call vimspector#Continue()<CR>", opts)

keymap("n", "<leader>db", "<cmd>call vimspector#ToggleBreakpoint()<CR>", opts)
keymap("n", "<leader>dB", "<cmd>call vimspector#ClearBreakpoints()<CR>", opts)

keymap("n", "<leader>dk", "<Plug>VimspectorRestart", opts)
keymap("n", "<leader>dh", "<Plug>VimspectorStepOut", opts)
keymap("n", "<leader>dl", "<Plug>VimspectorStepInto", opts)
keymap("n", "<leader>dj", "<Plug>VimspectorStepOver", opts)

-- Nuake --
keymap("n", "~~", "<cmd>Nuake<CR>", opts)
keymap("i", "~~", "<cmd>Nuake<CR>", opts)
keymap("t", "~~", "<C-\\><C-N><cmd>Nuake<CR>", term_opts)
