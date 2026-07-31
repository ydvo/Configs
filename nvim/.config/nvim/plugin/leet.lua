require("leetcode").setup({
  lang = "cpp",
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    if vim.bo[args.buf].filetype == "leetcode.nvim" then
      vim.defer_fn(function()
        vim.api.nvim_set_hl(0, "LeetCodeFloat", {
          fg = "#e2e2e2",
          bg = "#131313",
        })

        vim.api.nvim_set_hl(0, "leetcode_dyn_p", {
          fg = "#e2e2e2",
        })
        vim.api.nvim_set_hl(0, "leetcode_dyn_p_code", {
          fg = "#b6cea3",
        })

        vim.api.nvim_set_hl(0, "leetcode_dyn_pre", {
          fg = "#dcc3a1",
        })

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == args.buf then
            vim.api.nvim_set_option_value(
              "winhighlight",
              "NormalFloat:LeetCodeFloat",
              { win = win }
            )
          end
        end
      end, 50)
    end
  end,
})

vim.api.nvim_create_autocmd("WinNew", {
  callback = function()
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype == "leetcode.nvim" then
          vim.api.nvim_set_option_value(
            "winhighlight",
            "NormalFloat:LeetCodeFloat",
            { win = win }
          )
        end
      end
    end)
  end,
})
