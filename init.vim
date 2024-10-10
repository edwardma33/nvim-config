" Options
set clipboard=unnamedplus " Enables the clipboard between Vim/Neovim and other applications.
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.



" Set up Go-specific settings
autocmd FileType go setlocal tabstop=4 shiftwidth=4 expandtab



" Automatically convert tabs to spaces in Go files on buffer read
autocmd FileType go retab



set noswapfile
set cursorline " Highlights the current line in the editor
set hidden " Hide unused buffers
set autoindent " Indent a new line
set inccommand=split " Show replacements in a split screen
set mouse=a " Allow to use the mouse in the editor
set number
set relativenumber " Shows the line numbers
set splitbelow splitright " Change the split screen behavior
set title " Show file title
set wildmenu " Show a more advance menu
set cc=120 " Show at 80 column a border for good code style
filetype plugin indent on   " Allow auto-indenting depending on file type
autocmd FileType markdown setlocal spell

set scrolloff=5
set spell " enable spell check (may need to download language package)
set spelllang=en
set ttyfast " Speed up scrolling in Vim
set termguicolors
" Set default indent to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
" Use spaces for tabs
set smarttab

" Show tabs as ^I characters

" for tabbing lines ove
set shiftwidth=4

" Enable auto-indentation
set autoindent
" set smartindent

" show whitespace
set list
set listchars=trail:⋅

" stop markdown from folding
autocmd FileType markdown setlocal nofoldenable




" Map the tab key to insert 4 spaces
inoremap <Tab> <Space><Space><Space><Space>

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'nvim-lua/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'smithbm2316/centerpad.nvim'
Plug 'scrooloose/nerdtree'
Plug 'aspeddro/pandoc.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-dadbod'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'morhetz/gruvbox'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'folke/tokyonight.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'epwalsh/obsidian.nvim'
Plug 'aurum77/live-server.nvim'
Plug 'pangloss/vim-javascript'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mlaursen/vim-react-snippets'
Plug 'windwp/nvim-ts-autotag'
Plug 'rose-pine/neovim'
Plug 'sts10/vim-pink-moon'
Plug 'shaunsingh/nord.nvim'
Plug 'nvimdev/dashboard-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'ryanoasis/vim-devicons'

"List ends here. Plugins become visible to Vim after this call.
call plug#end()
colorscheme nord

let mapleader = " "


" Map <Leader>gd to go to definition
nnoremap <leader>gd :call CocAction('jumpDefinition')<CR>

nnoremap <leader>s :source%<CR>

nnoremap <C-q> :q!<CR>
nnoremap <F4> :bd<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <C-`> :sp<CR>:terminal<CR>
" Map Tab for autocompletion in insert mode
inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

inoremap <C-Right> <esc>$i


" Tabs
nnoremap <S-Tab> gT
nnoremap <Tab> gt
nnoremap <silent> <S-t> :tabnew<CR>

" Autosave (needs turned off for Telescope)
"augroup AutoSave
"au!
"autocmd BufLeave,FocusLost * update
"augroup END
    


" Tree-sitter configuration using Vimscript
augroup treesitter_highlight
    autocmd!
    autocmd VimEnter * TSEnable highlight
augroup END

"Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>t <cmd>Telescope<cr>

autocmd FileType markdown colorscheme catppuccin-frappe
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

lua << EOF
require'dashboard'.setup{
    shortcut_type = 'number'
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'nord',
     section_separators = { left = '', right = '' },
     component_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
  
}
EOF
