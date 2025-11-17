return {
  "folke/trouble.nvim",
  opts = {}, -- default options, can be customized here
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      function() require("trouble").toggle("diagnostics") end,
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      function() require("trouble").toggle("diagnostics", { buffer = 0 }) end,
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      function() require("trouble").toggle("symbols", { focus = false }) end,
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      function() require("trouble").toggle("lsp", { focus = false, position = "right" }) end,
      desc = "LSP Definitions / References (Trouble)",
    },
    {
      "<leader>xL",
      function() require("trouble").toggle("loclist") end,
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      function() require("trouble").toggle("qflist") end,
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>xn",
      function() require("trouble").next({ skip_groups = true, jump = true }) end,
      desc = "Go to Next item (Trouble)",
    },
    {
      "<leader>xp",
      function() require("trouble").prev({ skip_groups = true, jump = true }) end,
      desc = "Go to Previous item (Trouble)",
    },
  },
}
