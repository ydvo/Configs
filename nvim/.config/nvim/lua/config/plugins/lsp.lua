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
      vim.lsp.config('tinymist', {
        settings = {
          formatterMode = "typstyle",
        },
      })

      -- setup clang for use with esp-idf
      vim.lsp.config("clangd", {
        cmd = {
          "/home/ydvo/.espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd",
          "--background-index",
          "--compile-commands-dir=build.clang",
          "--query-driver=/home/ydvo/.espressif/tools/**",
        },
      })

      -- setup sourcekit for use without dynamic registration from swift install instructions
      vim.lsp.config("sourcekit", {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
        filetypes = { 'swift' },
      })

      -- enable server configurations
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('tinymist')
      vim.lsp.enable('ty')
      vim.lsp.enable('ruff')
      vim.lsp.enable('clangd')
      vim.lsp.enable('sourcekit')
      vim.lsp.enable('qmlls')
    end,
  }
}
