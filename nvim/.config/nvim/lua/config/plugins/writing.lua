return {
  {
    "preservim/vim-pencil"
  },
  -- {
  --   "folke/twilight.nvim"
  -- },
  {
    "folke/zen-mode.nvim",
    opts = {
      twilight = false,         -- disable Twilight
      options = {
        signcolumn = "no",      -- disable signcolumn
        number = false,         -- disable number column
        relativenumber = false, -- disable relative numbers
        -- cursorline = false,
        -- cursorcolumn = false,
        -- foldcolumn = "0",
        -- list = false,
      },
    },
  }
}
