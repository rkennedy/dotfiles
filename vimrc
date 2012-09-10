set nocompatible " not vi-compatible
set guifont=Lucida\ Sans\ Typewriter
syntax on
set foldcolumn=2 " left columns for code-folding indicators
set guioptions-=T " disable tool bar
set ruler
set hlsearch " highlight all search results

set expandtab " insert spaces instead of tabs
set tabstop=4 " tab characters take up four columns
set shiftwidth=4 " '<' and '>' shift code four spaces
set cindent

set term=xtermc

" Don't try to connect to X server for clipboard support; it's unlikely
" the X server on my systems will be active.
set clipboard=exclude:.*

set formatoptions+=r " automatically insert comment-continuation char

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

colorscheme desert