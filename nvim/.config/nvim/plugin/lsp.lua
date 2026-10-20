require('lazydev').setup()

-- Server configs
vim.lsp.config('tinymist', {
  settings = {
    formatterMode = "typstyle",
  },
})

-- rust-analyzer tuning that applies to every Rust project (so no per-project
-- rust-analyzer.toml is needed). Especially important for CargoBrazil packages
-- with an expensive build.rs (brazil-path shell-outs, bindgen/LIBCLANG, Cap'n
-- Proto codegen) and a huge shared Brazil target dir: on defaults RA re-checks
-- every bin/test target and re-fingerprints that tree on each save, causing
-- multi-GB memory use and long stalls.
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        -- allTargets = true (RA default) so on-save diagnostics also cover
        -- src/bin/* (emulator), simulators, and tests/ — consistent with
        -- keeping those files fully working. Omitted = default true.
        -- Scope the check to this package, not the whole workspace graph.
        workspace = false,
      },
      cargo = {
        -- Share the project's existing target dir with terminal builds. (Do
        -- NOT set targetDir = true: it points RA at target/rust-analyzer,
        -- which doesn't exist until RA's first check creates it, so the client
        -- file watcher can't resolve the path and spams "notify error: No path
        -- was found", leaving the LSP half-dead until :LspCargoReload. cargo's
        -- own file locking handles the occasional editor/terminal overlap.)
        buildScripts = {
          enable = true,
          -- Don't re-run build scripts (bindgen/clang + Cap'n Proto codegen in
          -- this crate's build.rs) on every save of a build-script/proc-macro
          -- source — only when explicitly reloaded. Pure win: no effect on
          -- which targets are analyzed.
          rebuildOnSave = false,
        },
        -- Keep allTargets = true (RA default) so code in src/bin/* (emulator),
        -- the simulators, and tests/ gets full completion/diagnostics.
        -- Tried allTargets = false to cut startup time but it made no
        -- measurable difference, so not worth losing bin/test analysis.
      },
      procMacro = { enable = true },
      -- Load dependency sources on demand instead of priming the whole graph.
      cachePriming = { enable = false },
      files = {
        -- Correct key is `exclude` (NOT `excludeDirs`, which this RA version
        -- ignores). Paths are relative to the workspace root; keep the watcher
        -- out of build output and non-source trees.
        exclude = { "build", "target", ".agents", "scripts" },
      },
    },
  },
})

vim.lsp.config("clangd", {
  -- cmd = {
  --   "/home/ydvo/.espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd",
  --   "--background-index",
  --   "--compile-commands-dir=build.clang",
  --   "--query-driver=/home/ydvo/.espressif/tools/**",
  -- },
})

-- enable server configurations
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('tinymist')
vim.lsp.enable('ty')
vim.lsp.enable('ruff')
vim.lsp.enable('clangd')
vim.lsp.enable('qmlls')
