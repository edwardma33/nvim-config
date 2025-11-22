-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>h", "<cmd>help option-list<cr>")
vim.keymap.set("n", "y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>us", "<cmd>.! cmp-us<cr>")
vim.keymap.set("n", "<leader>st", "<cmd>.! cmp-structtag<cr>")

vim.diagnostic.config({
  virtual_text = false,  -- disable inline text
  float = {
    show_header = true,
    source = true,
    border = "rounded",
  },
})

-- Show diagnostics in a float when you hover
vim.keymap.set("n", "K", vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- autocmds
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

-- Proper shifting/indenting
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- syntax/appearance
vim.opt.syntax = "enable"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",         -- Tab character
  trail = "·",        -- Trailing whitespace
  extends = "»",      -- Lines that extend past the window
  precedes = "«",     -- Lines that precede the window
  space = "·",        -- Normal space (optional—use with care)
}



vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- or "■", "▶", "◆", etc.
    spacing = 2,
    source = "always",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})


-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "config.plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, auto_update = true, },
})
-- In init.lua
vim.api.nvim_set_hl(0, "markdownItalic", { italic = true })
vim.api.nvim_set_hl(0, "markdownBold", { bold = true })

vim.cmd("colorscheme catppuccin-macchiato")
