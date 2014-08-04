silent! execute pathogen#infect()

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

" Don't try to connect to X server for clipboard support; it's unlikely
" the X server on my systems will be active.
set clipboard=exclude:.*

set formatoptions+=r " automatically insert comment-continuation char
set cinoptions+=l1 " align code under case label, not brace
set cinoptions+=t0 " don't indent function return type
set cinoptions+=(0 " align with unclosed parenthesis ...
set cinoptions+=W4 " ... unless it's at the end of a line
set cinoptions+=g0 " align C++ visibility with the enclosing block

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

colorscheme solarized

if !empty($POWERLINE_HOME)
	set runtimepath+=$POWERLINE_HOME/bindings/vim
endif
