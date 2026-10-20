-- Gitsigns: change signs in the gutter, toggle, and jump between hunks.
local gs = require("gitsigns")

gs.setup({
  on_attach = function(bufnr)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("]c", function() gs.nav_hunk("next") end, "Git: next hunk")
    map("[c", function() gs.nav_hunk("prev") end, "Git: previous hunk")
    map("<leader>gt", gs.toggle_signs, "Git: toggle signs")
    map("<leader>gg", function() gs.setqflist("all") end, "Git: all hunks to quickfix")
    -- Shadows the native `gp` (paste-and-advance) in git-tracked buffers.
    map("gp", gs.preview_hunk_inline, "Git: preview hunk inline")
  end,
})
