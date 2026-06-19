local cr = require("code_review")

vim.keymap.set("n", "<leader>cr", cr.show_status, { desc = "Code Review status" })
vim.keymap.set("n", "<leader>cs", function()
  -- Пример: выбрать статус через vim.ui.select
  vim.ui.select({ "todo", "in_progress", "reviewed", "needs_refactor", "blocked" }, {
    prompt = "Set review status",
  }, function(choice)
    if choice then
      cr.set_status(choice, vim.fn.input("Notes: "))
    end
  end)
end, { desc = "Set Code Review status" })

vim.keymap.set("n", "<leader>cS", cr.stats, { desc = "Code Review statistics" })