return {
  'DAmesberger/sc-im.nvim',
  config = function()
    require('sc-im').setup({
      ft = 'scim',
      include_sc_file = true,
      update_sc_from_md = true,
      link_fmt = 1,
      split = "floating",
      float_config = {
        height = 0.9,
        width = 0.9,
        style = 'minimal',
        border = 'single',
        hl = 'Normal',
        blend = 0
      }
    })
  end,
}
