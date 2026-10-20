-- user_functions.lua
--    collection of user defined functions
local M = {}
local terminal_bufnr = nil

-- Function to toggle terminal window
function M.terminal_toggle()
  return function()
    if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
      -- If terminal already exists, go to it
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
          vim.api.nvim_set_current_win(win)
          vim.cmd.startinsert()
          return
        end
      end
      -- Terminal buffer exists but not visible, open it in split
      vim.cmd.new()
      vim.api.nvim_win_set_buf(0, terminal_bufnr)
      vim.api.nvim_win_set_height(0, 15)
      vim.cmd.startinsert()
    else
      -- Terminal doesn't exist, create it
      vim.cmd.new()
      vim.cmd.term()
      vim.api.nvim_win_set_height(0, 15)
      vim.cmd.startinsert()
      terminal_bufnr = vim.api.nvim_get_current_buf()
    end
  end
end

-- Auto-close pairs with space after opening in insert mode
function M.autopair(open, close)
  return function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    -- Check if cursor is at end or followed by whitespace
    if col > #line or line:sub(col, col):match("%s") then
      return open .. close .. "<Left>"
    else
      return open
    end
  end
end

-- Overtyping closers
function M.overtype(char)
  return function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    if line:sub(col, col) == char then
      return "<Right>" -- move past existing closer
    else
      return char      -- insert it normally
    end
  end
end

-- Auto-close quotes with space after opening in insert mode
--    and overtypes closing quotes
function M.autopair_quotes(char)
  return function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    -- Check if cursor is at end or followed by whitespace
    if col > #line or line:sub(col, col):match("%s") then
      return char .. char .. "<Left>"
    elseif line:sub(col, col) == char then
      return "<Right>" -- move past closer
    else
      return char
    end
  end
end

-- Run Typst watch and open zathura
function M.typstwatch()
  return function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r") .. ".pdf"

    -- start typst watch
    vim.fn.jobstart({ "typst", "watch", file, out })
    -- Open zathura
    vim.fn.jobstart({ "zathura", out })
  end
end

-- AutoCommands
-- Auto Format on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Check for tinymist
    if client.name == "tinymist" then
      -- Force-enable formatting capability
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end

    -- ensure lsp supports formatting
    -- Rust is handled by a dedicated rustfmt-on-save autocmd below (not via the
    -- LSP), so skip it here to avoid double-formatting.
    if client:supports_method('textDocument/formatting')
      and vim.bo[args.buf].filetype ~= "rust" then
      -- create group to prevent duplicates
      local group = vim.api.nvim_create_augroup(
        "LspFormat_" .. args.buf,
        { clear = true }
      )

      -- Auto-format ("lint") on save.
      -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = group,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- Rust format-on-save via standalone rustfmt.
-- rustfmt itself is fast (~0.5s worst case on a 7k-line file; usually <200ms).
-- The multi-second save stalls come from routing formatting through
-- rust-analyzer, whose requests queue behind cargo check / proc-macro work.
-- Calling rustfmt directly keeps saves fast and still writes a formatted file
-- (synchronous). Edition / style are read from the project's Cargo.toml and
-- rustfmt.toml automatically, so this stays correct across all Rust projects.
--
-- We resolve the real binary via `rustup which rustfmt` because the rustup
-- shim (and the Brazil s3-safe-proxy) print chatter on stderr. We use
-- vim.system(), which keeps stdout and stderr in SEPARATE fields, so that
-- chatter can never reach the buffer. The resolved path is cached per cwd.
local rustfmt_cache = {}
local function resolve_rustfmt()
  local cwd = vim.fn.getcwd()
  local cached = rustfmt_cache[cwd]
  if cached ~= nil then return cached end
  local path = "rustfmt" -- fallback
  local res = vim.system({ "rustup", "which", "rustfmt" }, { text = true }):wait()
  if res.code == 0 and res.stdout then
    local line = vim.trim(res.stdout)
    if line ~= "" then path = line end
  end
  rustfmt_cache[cwd] = path
  return path
end

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup("RustFmtOnSave", { clear = true }),
  pattern = "*.rs",
  callback = function(args)
    local view = vim.fn.winsaveview()
    local input = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), "\n")
    -- vim.system separates stdout/stderr: proxy/shim chatter on stderr is
    -- discarded, only formatted code on stdout is read.
    local res = vim.system(
      { resolve_rustfmt(), "--emit", "stdout" },
      { stdin = input, text = true }
    ):wait()
    -- Only apply on clean success with real output; on error leave the buffer
    -- untouched so a syntax error mid-edit never blanks the file.
    if res.code == 0 and res.stdout and res.stdout ~= "" then
      local out = vim.split(res.stdout, "\n", { plain = true })
      -- rustfmt's stdout ends with a trailing newline → drop the empty last
      -- element so we don't append a blank line on every save.
      if out[#out] == "" then table.remove(out) end
      local cur = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
      if not vim.deep_equal(cur, out) then
        vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, out)
      end
    end
    vim.fn.winrestview(view)
  end,
})

-- -- Adjust colorscheme
vim.api.nvim_create_autocmd('Colorscheme', {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  end,
})

return M
