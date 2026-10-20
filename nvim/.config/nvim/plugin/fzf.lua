local fzf = require("fzf-lua")

fzf.setup({
  actions = {
    files = {
      -- restore default behaviour
      ["enter"]  = fzf.actions.file_edit_or_qf,
      ["ctrl-s"] = fzf.actions.file_split,
      ["ctrl-v"] = fzf.actions.file_vsplit,
      ["ctrl-t"] = fzf.actions.file_tabedit,
      ["alt-q"]  = fzf.actions.file_sel_to_qf,

      -- custom action
      ["ctrl-o"] = function(selected, opts)
        local path = require("fzf-lua.path")
        for _, entry in ipairs(selected) do
          local file = path.entry_to_file(entry, opts)
          vim.ui.open(file.path)
        end
      end,
    },
  },

  keymap = {
    fzf = {
      ["ctrl-n"] = "down",
      ["ctrl-p"] = "up",
    },
  },
})
