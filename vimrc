set nocompatible " not vi-compatible

" Begin Vundle setup
filetype off
set runtimepath+=$HOME/.vim/bundle/vundle
call vundle#rc()

Plugin 'gmarik/vundle'

" Status line enhancement
Plugin 'bling/vim-airline'
let g:airline_powerline_fonts=1
let g:airline_theme='powerlineish'
" Change words to other variants
Plugin 'tpope/vim-abolish'
" Solarized color scheme
Plugin 'altercation/vim-colors-solarized'
" Delphi syntax highlighting
Plugin 'rkennedy/vim-delphi'
" Handle Git files
Plugin 'tpope/vim-git'
" Show changed lines in gutter
Plugin 'airblade/vim-gitgutter'
" Markdown syntax highlighting
Plugin 'tpope/vim-markdown'
" Repeat commands
Plugin 'tpope/vim-repeat'
" Default Vim settings
Plugin 'tpope/vim-sensible'
" Copy and paste between tmux windows
Plugin 'tpope/vim-tbone'
" Pairs of keyboard motions
Plugin 'tpope/vim-unimpaired'
" Tmux syntax highlighting
Plugin 'peterhoeg/vim-tmux'
" Operate Git within Vim
Plugin 'tpope/vim-fugitive'
" Detect and apply indentation settings
Plugin 'tpope/vim-sleuth'
" Python indentation settings
Plugin 'hynek/vim-python-pep8-indent'

" Also check for local .vimrc file
" End Vundle setup

set guifont=Lucida\ Sans\ Typewriter
syntax on
set foldcolumn=2 " left columns for code-folding indicators
set guioptions-=T " disable tool bar
set ruler
set hlsearch " highlight all search results

set colorcolumn=80 " highlight column 80

" Don't try to connect to X server for clipboard support; it's unlikely
" the X server on my systems will be active.
set clipboard=exclude:.*

set formatoptions+=r " automatically insert comment-continuation char
set cinoptions+=l1 " align code under case label, not brace
set cinoptions+=t0 " don't indent function return type
set cinoptions+=(0 " align with unclosed parenthesis ...
set cinoptions+=W4 " ... unless it's at the end of a line
set cinoptions+=g0 " align C++ visibility with the enclosing block

if exists('+undofile')
	let s:dir = has('win32')
		\ ? '$APPDATA/Vim'
		\ : match(system('uname'), "Darwin") > -1
			\ ? '~/Library/Vim'
			\ : empty($XDG_DATA_HOME)
				\ ? '~/.local/share/vim'
				\ : '$XDG_DATA_HOME/vim'
	let &undodir = expand(s:dir) . '/undo'
	set undofile
endif

" Open new windows below (:new) or right (:vnew) of the current window
set splitbelow splitright

filetype plugin indent on

if $NO_SOLARIZED == 1
	colorscheme desert
else
	colorscheme solarized
endif

silent! source $HOME/dotfiles.local/vimrc
