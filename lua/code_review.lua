local M = {}

local status_file = vim.fn.getcwd() .. "/code_review_status.json"

local status_colors = {
  todo           = { level = vim.log.levels.INFO,   hl = "NotifyInfo" },
  in_progress    = { level = vim.log.levels.WARN,   hl = "NotifyWarn" },
  reviewed       = { level = vim.log.levels.INFO,   hl = "NotifyOK" },
  needs_refactor = { level = vim.log.levels.ERROR,  hl = "NotifyError" },
  blocked        = { level = vim.log.levels.ERROR,  hl = "NotifyError" },
}

local function read_status()
  if vim.fn.filereadable(status_file) == 0 then
    return { files = {} }
  end

  local lines = vim.fn.readfile(status_file)
  if #lines == 0 then
    return { files = {} }
  end

  local content = table.concat(lines, "\n")
  local ok, data = pcall(vim.fn.json_decode, content)
  if not ok or not data then
    vim.notify("Warning: corrupted code_review_status.json, starting fresh", vim.log.levels.WARN)
    return { files = {} }
  end

  return data
end

local function write_status(data)
  local ok, encoded = pcall(vim.fn.json_encode, data)
  if ok then
    vim.fn.writefile({ encoded }, status_file)
  else
    vim.notify("Failed to write status file", vim.log.levels.ERROR)
  end
end

local function get_rel_path()
  local full = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  return full:sub(#cwd + 2)
end

function M.show_status()
  local data = read_status()
  local rel = get_rel_path()
  local file_data = data.files[rel]

  if not file_data or not file_data.status then
    return
  end

  local cfg = status_colors[file_data.status] or { level = vim.log.levels.INFO }
  local msg = "● " .. file_data.status:upper()

  if file_data.notes then
    msg = msg .. " | " .. file_data.notes
  end
  if file_data.time_spent_days then
    msg = msg .. string.format(" (%d)", file_data.time_spent_days)
  end

  vim.notify(msg, cfg.level, {
    title = "Code Review • " .. rel,
    timeout = 3500,
  })
end

function M.set_status(status, notes)
  local data = read_status()
  local rel = get_rel_path()

  if not data.files[rel] then
    data.files[rel] = {}
  end

  data.files[rel].status = status
  data.files[rel].reviewed_at = os.date("%Y-%m-%d")
  if notes and notes ~= "" then
    data.files[rel].notes = notes
  end

  write_status(data)
  vim.notify("✅ Status changed: " .. status, vim.log.levels.INFO, { title = "Code Review" })
  M.show_status()
end

function M.stats()
  local data = read_status()
  local total = vim.tbl_count(data.files)
  local reviewed = 0
  for _, f in pairs(data.files) do
    if f.status == "reviewed" then reviewed = reviewed + 1 end
  end

  local percent = total > 0 and math.floor(reviewed / total * 100) or 0
  local msg = string.format("Total: %d files\nReviewed: %d (%d%%)", total, reviewed, percent)

  vim.notify(msg, vim.log.levels.INFO, { title = "Code Review Statistics", timeout = 7000 })
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = {"*.cpp", "*.hpp", "*.c", "*.h", "*.cc", "*.cxx", "*.cmake", "*.lua", "*.vim"},
  callback = function()
    vim.defer_fn(M.show_status, 250)
  end,
})

return M
