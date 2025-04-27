local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  keymap = {
    fzf = {
      -- use cltr-q to select all items and convert to quickfix list
      ["ctrl-q"] = "select-all+accept",
    },
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
  },
  winopts = {
    fullscreen = true,
  },
})

-- use `fzf-lua` for replace vim.ui.select 
fzf_lua.register_ui_select()
