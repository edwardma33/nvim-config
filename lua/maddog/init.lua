local M = {}

function M.hello()
  local row, _ = unpack(vim.api.nvim_buf_get_mark(0, "."))
  local line = vim.api.nvim_buf_get_lines(0, row, row, false)[1]
  print(line)
end

vim.api.nvim_create_user_command("Maddog", function ()
  require("maddog").hello() 
  end,
  {}
)
