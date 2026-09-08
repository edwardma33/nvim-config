local nvim_cfg_path = os.getenv("MYVIMRC")

-- keymaps
vim.keymap.set('n', '<leader>o', string.format(':source %s<CR>', nvim_cfg_path))
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')

-- Bring up window with error description
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { focus = false })
end
)

vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")

vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)

vim.keymap.set('n', '<leader>nt', ":tabnext<CR>")
vim.keymap.set('n', '<leader>c', ":tabnew<CR>")
vim.keymap.set('n', '<C-w><C-`>', ":split | wincmd j | terminal<CR>")

vim.keymap.set('n', '<leader>t', ":lua MiniFiles.open()<CR>")

vim.keymap.set('n', '<leader>xb', ":XcodebuildBuild<CR>", { desc = "Xcodebuild build" })
vim.keymap.set('n', '<leader>xr', ":XcodebuildBuildRun<CR>", { desc = "Xcodebuild build and run" })
vim.keymap.set('n', '<leader>xt', ":XcodebuildTest<CR>", { desc = "Xcodebuild test" })
vim.keymap.set('n', '<leader>xp', ":XcodebuildPicker<CR>", { desc = "Xcodebuild picker" })
vim.keymap.set('n', '<leader>xs', ":XcodebuildSetup<CR>", { desc = "Xcodebuild setup" })

vim.keymap.set('v', '<leader>oa', function ()
  require('opencode').ask("@this: ", { submit = true })
end)

vim.keymap.set("n", '<leader>l', function ()
  local wrapped = not vim.wo.wrap

  vim.wo.wrap = wrapped
  vim.wo.linebreak = wrapped
end, { desc = "Toggle wrap and linebreak" })
