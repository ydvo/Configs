return {
  {
    "ydvo/vim-moonfly-oled",
    -- config = function()
    --   vim.cmd.colorscheme "moonfly"
    -- end
  },
  {
    "rebelot/kanagawa.nvim"
  },
  {
    "oskarnurm/koda.nvim"
  },
  {
    "silentium-theme/silentium.nvim",
    config = function()
      require("silentium").setup({
        accent = "#fdbb4a",
        dark = "#131313"
      })

      vim.cmd.colorscheme "silentium"
    end
  },
  {
    "savq/melange-nvim"
  },

}
