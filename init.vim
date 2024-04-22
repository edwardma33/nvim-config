" Options
set clipboard=unnamedplus " Enables the clipboard between Vim/Neovim and other applications.
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.
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
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'ryanoasis/vim-devicons'
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

"List ends here. Plugins become visible to Vim after this call.
call plug#end()
colorscheme kanagawa

let mapleader = " "

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

" Autosave
augroup AutoSave
    au!
    autocmd BufLeave,FocusLost * update
augroup END
