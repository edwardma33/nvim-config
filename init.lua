function gh(project_path)
  return string.format("https://github.com/%s", project_path)
end


-- Plugins
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/altermo/ultimate-autopair.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = gh("nvim-mini/mini.surround") },
  { src = gh("tpope/vim-fugitive") }
})

-- my modules
require('options')
require('keymaps')
require('lsp')
require('file-explorer')

-- other
require('mini.surround').setup()
require ('mini.icons').setup()
require ("ultimate-autopair").setup()

-- start commands
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

vim.cmd.colorscheme("catppuccin-macchiato")
