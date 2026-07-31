-- Load all packages before configuration
-- Should be first alphabetically in `plugin/`
vim.pack.add({
  -- Alpa
  "https://github.com/goolord/alpha-nvim",

  -- Blink Cmp
  "https://github.com/saghen/blink.lib", "https://github.com/saghen/blink.cmp",
  "https://github.com/rafamadriz/friendly-snippets",

  -- Colorschemes
  "https://github.com/ydvo/vim-moonfly-oled",
  "https://github.com/silentium-theme/silentium.nvim",

  -- Fzf
  "https://github.com/ibhagwan/fzf-lua",

  -- Lsp
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",

  --Leet
  "https://github.com/kawre/leetcode.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",

  -- Neogen
  "https://github.com/danymat/neogen",

  -- Notify
  "https://github.com/rcarriga/nvim-notify",

  -- Oil
  "https://github.com/stevearc/oil.nvim", "https://github.com/nvim-tree/nvim-web-devicons",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  -- Whichkey
  "https://github.com/folke/which-key.nvim",

  -- Zen
  "https://github.com/folke/zen-mode.nvim"
})

-- One line cfgs
require("oil").setup({})
require("neogen").setup({})
require("leetcode").setup({
  lang = "cpp",
})
