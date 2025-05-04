require("better_escape").setup {
  timeout = vim.o.timeoutlen,
  default_mappings = false,
  mappings = {
    i = {
      j = {
        j = "<Esc>",
      },
    },
  },
}
