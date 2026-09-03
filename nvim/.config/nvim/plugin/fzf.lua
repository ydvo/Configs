local fzf = require('fzf-lua')

fzf.setup({
  actions = {
    files = {
      ["ctrl-o"] = function(selected, opts)
        local path = require('fzf-lua.path')
        for _, entry in ipairs(selected) do
          local file = path.entry_to_file(entry, opts)
          vim.ui.open(file.path)
        end
      end,
    },
  },
})
