-- Load all packages before configuration
-- Should be first alphabetically in `plugin/`

-- Plugin build hooks. Must be registered before vim.pack.add() so they fire on install.
-- Rebuild blink.cmp's Rust fuzzy matcher only when it is installed/updated, asynchronously,
-- instead of blocking startup with build():pwait() on every launch.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == "blink.cmp" and (d.kind == "install" or d.kind == "update") then
      vim.notify("Building blink.cmp...")
      vim.system({ "cargo", "build", "--release" }, { cwd = d.path }, function(r)
        vim.schedule(function()
          vim.notify(r.code == 0 and "blink.cmp built" or ("blink.cmp build failed:\n" .. (r.stderr or "")))
        end)
      end)
    end
  end,
})

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

  -- Gitsigns
  "https://github.com/lewis6991/gitsigns.nvim",

  -- Lsp
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",

  --Leet
  -- "https://github.com/kawre/leetcode.nvim",
  -- "https://github.com/nvim-lua/plenary.nvim",
  -- "https://github.com/MunifTanjim/nui.nvim",

  -- Markdown
  "https://github.com/meanderingprogrammer/render-markdown.nvim",

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

  -- Icons
  "https://github.com/nvim-tree/nvim-web-devicons",

  -- Zen
  "https://github.com/folke/zen-mode.nvim"
})

-- One line cfgs
require("oil").setup({})
require("neogen").setup({})
-- require("leetcode").setup({
--   lang = "cpp",
-- })
