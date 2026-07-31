require("nvim-treesitter").setup({
  ensure_installed = {
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
    "rust"
  },

  highlight = {
    enable = true,
  },

  indent = {
    enable = true,
  },
})

require("treesitter-context").setup({
  max_lines = 4,
  multiline_threshold = 2,
})
