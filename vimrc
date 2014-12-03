set nocompatible " not vi-compatible

" Begin Vundle setup
filetype off
set runtimepath+=$HOME/.vim/bundle/vundle
call vundle#rc()

Plugin 'gmarik/vundle'

Plugin 'tpope/vim-abolish'
Plugin 'altercation/vim-colors-solarized'
Plugin 'rkennedy/vim-delphi'
Plugin 'tpope/vim-git'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-unimpaired'
Plugin 'peterhoeg/vim-tmux'
Plugin 'tpope/vim-fugitive'

" Also check for local .vimrc file
" End Vundle setup

set guifont=Lucida\ Sans\ Typewriter
syntax on
set foldcolumn=2 " left columns for code-folding indicators
set guioptions-=T " disable tool bar
set ruler
set hlsearch " highlight all search results

set expandtab " insert spaces instead of tabs
set tabstop=4 " tab characters take up four columns
set shiftwidth=4 " '<' and '>' shift code four spaces
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

" Open new windows below (:new) or right (:vnew) of the current window
set splitbelow splitright

filetype plugin indent on

" Makefiles require real tabs, not spaces.
autocmd BufEnter ?akefile* set noexpandtab tabstop=8 shiftwidth=8

function RK_settabs()
	" Count how many lines start with tab. Compare to the number of
	" lines starting with four spaces. If tabs win, then set options.
	if len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^\\t"')) > len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^    "'))
		set noexpandtab tabstop=8 shiftwidth=8
	endif
endfunction
autocmd BufReadPost * call RK_settabs()

if $NO_SOLARIZED == 1
	colorscheme desert
else
	colorscheme solarized
endif

if !empty($POWERLINE_HOME)
	set runtimepath+=$POWERLINE_HOME/bindings/vim
endif

silent! source $HOME/dotfiles.local/vimrc
