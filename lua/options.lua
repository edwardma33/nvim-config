-- Basics
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.scrolloff = 10
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.syntax = "on"
vim.o.clipboard = "unnamedplus"
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",         -- Tab character
  trail = "·",        -- Trailing whitespace
  extends = "»",      -- Lines that extend past the window
  precedes = "«",     -- Lines that precede the window
  space = "·",        -- Normal space (optional—use with care)
}

-- Visuals
vim.opt.termguicolors = true
