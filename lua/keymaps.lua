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

vim.keymap.set('v', '<leader>oa', function ()
  require('opencode').ask("@this: ", { submit = true })
end)
