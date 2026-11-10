-- Gitsigns: change signs in the gutter, toggle, and jump between hunks.
local gs = require("gitsigns")

-- Inline blame for the cursor line, cleared on the next cursor move. Done by
-- hand because gitsigns' current_line_blame re-shows itself after being
-- toggled off (a pending update isn't cancelled).
local blame_ns = vim.api.nvim_create_namespace("user_inline_blame")

local function show_inline_blame()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fs.dirname(file)
  local lnum = vim.fn.line(".")
  -- --contents - blames the buffer as edited, so unsaved changes line up.
  local out = vim.fn.system({ "git", "-C", dir, "blame", "--porcelain", "-L", lnum .. "," .. lnum,
    "--contents", "-", "--", file }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  local sha = vim.v.shell_error == 0 and out:match("^%x+")
  if not sha then return end

  local text = sha:match("^0+$") and "You, Uncommitted changes"
    or vim.trim(vim.fn.system({ "git", "-C", dir, "show", "-s", "--format=%an, %ar - %s", sha }))
  vim.api.nvim_buf_set_extmark(0, blame_ns, lnum - 1, 0, {
    virt_text = { { "    " .. text, "GitSignsCurrentLineBlame" } },
  })
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
    once = true,
    callback = function() pcall(vim.api.nvim_buf_clear_namespace, bufnr, blame_ns, 0, -1) end,
  })
end

-- Toggle gitsigns' file blame split. Global so it also works from inside the
-- blame window.
vim.keymap.set("n", "gB", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-blame" then
      return vim.api.nvim_win_close(win, false)
    end
  end
  gs.blame()
end, { desc = "Git: toggle file blame split" })

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
    map("gb", show_inline_blame, "Git: show inline blame")
  end,
})
