local ts = require("nvim-treesitter")

ts.setup({})

-- Parsers to keep installed (main-branch API: install() replaces ensure_installed)
local ensure_installed = {
  "bash",
  "c",
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "python",
  "gitignore",
  "typst",
  "rust",
}

-- Install any that are missing (async; no-op if already present)
ts.install(ensure_installed)

-- On the main branch, highlighting is NOT a module you enable in setup().
-- You must start treesitter per-buffer yourself.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    -- Only start if a parser is available for this filetype's language
    local lang = vim.treesitter.language.get_lang(ft)
    if lang and pcall(vim.treesitter.language.add, lang) then
      pcall(vim.treesitter.start, args.buf, lang)
      -- treesitter-based indentation
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("treesitter-context").setup({
  max_lines = 4,
  multiline_threshold = 2,
})
