local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  keymap = {
    fzf = {
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

fzf_lua.register_ui_select()