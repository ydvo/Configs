return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    -- config = function()
    --   require 'fzf-lua'.setup {
    --     actions = {
    --       files = {
    --         -- override default <CR> action
    --         ["default"] = function(selected, opts)
    --           local file = selected[1]
    --           print("Chekcing")
    --           if file:match("%.png$") or file:match("%.jpg$") or file:match("%.jpeg$")
    --               or file:match("%.gif$") or file:match("%.pdf$") then
    --             -- use xdg-open for images and PDFs
    --             print("Opening externally...")
    --             vim.fn.jobstart({ "xdg-open", file }, { detach = true })
    --           else
    --             -- fallback to default file edit
    --             require("fzf-lua.actions").file_edit(selected, opts)
    --           end
    --         end,
    --       },
    --     },
    --   }
    -- end
  }
}
