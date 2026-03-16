return {
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      require("oil").setup({
        -- view_options = { show_hidden = true, },
        keymaps = {
          ["<C-o>"] = function()
            local file = require("oil").get_cursor_entry().name
            vim.fn.jobstart({ "xdg-open", file }, { detach = true })
          end,
        },
      })
    end,
  }
}
