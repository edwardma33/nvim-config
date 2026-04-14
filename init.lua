-- helpler function to add gh prefix
local function gh(project_path)
  return string.format("https://github.com/%s", project_path)
end

-- Plugins
vim.pack.add({
  { src = gh("catppuccin/nvim") },
  { src = gh("stevearc/oil.nvim") },
  { src = gh("echasnovski/mini.pick") },
  { src = gh("altermo/ultimate-autopair.nvim") },
  { src = gh("neovim/nvim-lspconfig") },
  { src = gh("nvim-treesitter/nvim-treesitter") },
  { src = gh("hrsh7th/nvim-cmp") },
  { src = gh("hrsh7th/cmp-nvim-lsp") },
  { src = gh("nvim-mini/mini.icons") },
  { src = gh("nvim-mini/mini.surround") },
  { src = gh("nvim-mini/mini.notify") },
  { src = gh("tpope/vim-fugitive") },
  { src = gh("sainnhe/everforest") },
  { src = gh("nvim-lua/plenary.nvim") },
  { src = gh("epwalsh/obsidian.nvim") },
  { src = gh("iamcco/markdown-preview.nvim") },
  { src = gh("MeanderingProgrammer/render-markdown.nvim") },
  { src = gh("reedes/vim-pencil") },
  { src = gh("mason-org/mason.nvim") },
  { src = gh("dstein64/vim-startuptime") },
  { src = gh("nvim-lualine/lualine.nvim") },
  { src = gh("rose-pine/neovim"), name = "rose-pine" },
  { src = gh("arcticicestudio/nord-vim") },
  { src = gh("nvim-mini/mini.files") },
  { src = gh("folke/lazydev.nvim") },
  { src = gh("folke/snacks.nvim") },
  { src = gh("NickvanDyke/opencode.nvim") },
  { src = gh("folke/tokyonight.nvim") },
  { src = gh("andersevenrud/nordic.nvim") }
})

-- my modules
require('options')
require('keymaps')
require('lsp')
require('file-explorer')

-- other
require('mini.surround').setup()
require('nvim-treesitter').setup()
require ('mini.icons').setup()
require('mini.notify').setup()
require('mini.files').setup()
require ("ultimate-autopair").setup({
  bs = {
    enable = false,
  }
})
require('lualine').setup({})
require ("mason").setup()
require('rose-pine').setup({
  variant = "moon",
})
require("render-markdown").setup({})
require("lazydev").setup()
require("snacks").setup()

-- start commands
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

vim.cmd.colorscheme("catppuccin-frappe")
