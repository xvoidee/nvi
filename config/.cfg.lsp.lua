vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = "cursor",
      border = "rounded",
    })
  end,
})

vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { border = "rounded" })
end, { desc = "Show diagnostics" })
