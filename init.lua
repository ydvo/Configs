-- init.lua

-- Options
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.showmode = false          -- hide -- INSERT -- etc.
vim.opt.smartcase = true          -- smart case search
vim.opt.smartindent = true        -- smarter auto-indenting
vim.opt.swapfile = false          -- disable swapfile
vim.opt.termguicolors = true      -- enable true colors
vim.opt.timeoutlen = 1000         -- shorter key sequence timeout
vim.opt.undofile = true           -- persistent undo
vim.opt.updatetime = 300          -- faster completion (default is 4000ms)
vim.opt.expandtab = true          -- tabs → spaces
vim.opt.shiftwidth = 2            -- 2 spaces for indent
vim.opt.tabstop = 2               -- 2 spaces per tab
vim.opt.number = true             -- line numbers
vim.opt.signcolumn = "yes"        -- always show sign column
vim.opt.wrap = false              -- no line wrap
vim.opt.scrolloff = 8             -- margin above/below cursor
vim.opt.sidescrolloff = 8         -- margin left/right of cursor

-- Requires
require("config.lazy")
require("config.keymaps")

-- AutoCommands

-- Auto Format on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
