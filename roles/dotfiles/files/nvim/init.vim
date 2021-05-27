source $HOME/.config/nvim/vim-plug/plugins.vim

" Only does anything in /etc/vimrc, as the presence of a user-scope vimrc
" automatically disables compatible mode
set nocompatible
" Show line numbers
set number
" Show relative line numbers (useful for editing with linewise movements)
set relativenumber
" Highlight the search term when you search for it, but don't highlight
" just because we've sourced vimrc
set hlsearch
" Expand tabs into spaces on insert
set expandtab
" Set tabstop to be size 2 (the standard at Google)
set ts=2
" Set shiftwidth to 2 to match tabstop
set sw=2
" Enable syntax highlighting
syntax on
" Enables good auto indentation
filetype plugin indent on
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256
" Show when the leader key is active
set showcmd
" Automatically change the working path to the path of the current file
autocmd BufNewFile,BufEnter * silent! lcd %:p:h
" Required by 'set list listchars' command down below
set encoding=utf-8
" use » to mark Tabs and ° to mark trailing whitespace. This is a
" non-obtrusive way to mark these special characters.
set list listchars=tab:»\ ,trail:°
" Do not automatically add 'end of line' symbol
set nofixeol
" Explicitly set the Leader to comma. You can use '\' (the default),
" or anything else (some people like ';').
let mapleader=','
" Enable folding
set foldmethod=indent
set foldlevelstart=99
" Directory for folds
set viewdir=~/.config/nvim/view
augroup AutoSaveGroup
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end
" Toggle fold at current position.
nnoremap <Tab> za
