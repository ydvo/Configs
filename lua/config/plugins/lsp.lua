return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- Server configs
      vim.lsp.config('basedpyright', {
        settings = {
          basedpyright = {
            analysis = {
              -- make it less strict:
              typeCheckingMode = "basic",       -- or "standard", or whatever level you prefer
              diagnosticMode = "openFilesOnly", -- so only open files are checked
              -- optionally override specific diagnostics
              diagnosticSeverityOverrides = {
                -- e.g. turn some errors into warnings or suppress them
                reportMissingTypeStubs = "warning",
                reportPrivateImportUsage = "none",
              },
            },
          },
        },
      })

      vim.lsp.config('tinymist', {
        settings = {
          formatterMode = "typstyle",
        },
      })

      -- enable server configurations
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("tinymist")
      vim.lsp.enable("basedpyright")
      vim.lsp.enable('ruff')
      vim.lsp.enable('clangd')
      vim.lsp.enable('clangd-format')
    end,
  }
}
