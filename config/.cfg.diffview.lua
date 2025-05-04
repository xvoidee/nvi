require('diffview').setup({
  enhanced_diff_hl = true,
  use_icons = false,
  view = {
    default = {
      layout = 'diff2_horizontal',
    },
  },
})

local function set_diff_highlights()
  vim.api.nvim_set_hl(0, 'DiffAdd'   , { fg = 'none'   , bg = '#3D4D36', bold = false })
  vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#5A3F3F', bg = '#4B3535', bold = false })
  vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none'   , bg = '#342F24', bold = false })
  vim.api.nvim_set_hl(0, 'DiffText'  , { fg = 'none'   , bg = '#6D7E99', bold = false })
end

set_diff_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group    = vim.api.nvim_create_augroup('DiffColors', { clear = true }),
  callback = set_diff_highlights
})

vim.opt.fillchars:append { diff = "╱" }
