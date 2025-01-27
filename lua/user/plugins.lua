--Lazyvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins

  -- colorthemes
  {"ydvo/vim-moonfly-oled", name = "moonfly"},
  "jacoborus/tender.vim",
  { 'kepano/flexoki-neovim', name = 'flexoki' },
  "rebelot/kanagawa.nvim",
  "marko-cerovac/material.nvim",
  { "rose-pine/neovim", name = "rose-pine" },

  -- cmp plugins
  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",

  -- snippets
  {
    "L3MON4D3/LuaSnip", --snippet engine
    config = function()
      require("luasnip").config.set_config({
        enable_autosnippets = true
      })
    end
  },
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- LSP
  "neovim/nvim-lspconfig", -- enable LSP
  "williamboman/mason.nvim", -- simple to use language server installer
  "williamboman/mason-lspconfig.nvim", -- simple to use language server installer

  -- Telescope
  "nvim-telescope/telescope.nvim",

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end
  },

  -- Comments
   {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Bufferline
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  -- Better Buffer Deletion
  "moll/vim-bbye",

  -- Oil
  {
    'stevearc/oil.nvim',
    event = "VeryLazy",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == '..' or name == '.git'
          end,
        },
        win_options = {
          wrap = true,
        }  })
    end,
  },

  -- Rainbow Delimiters
  "HiPhish/rainbow-delimiters.nvim",

  -- -- Surround !Conflicts with leap
  -- {
  --   "kylechui/nvim-surround",
  --   version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   config = function()
  --       require("nvim-surround").setup({
  --           -- Configuration here, or leave empty to use defaults
  --       })
  --   end
  -- },

  -- Start Screen
  "goolord/alpha-nvim",

  -- WhichKey
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 10, -- how many suggestions should be shown in the list?
    },
    }
  },

  "preservim/vim-pencil",

  "folke/twilight.nvim",

  {
    "folke/zen-mode.nvim",
    opts = {
    }
  },

  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
  },

  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },

  {
    "marcusfschmidt/vim-matlab",
    event = "VeryLazy",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.matlab_auto_mappings = 0
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      --Vimtex configuration
      vim.g.vimtex_view_method = "zathura"
    end
  },

  {
    'puremourning/vimspector',
    event = "VeryLazy",
  },

}

local opts = {}

require("lazy").setup(plugins, opts)
