set nocompatible " not vi-compatible

function RKGetSignifyHLGroup(lineno)
  " Description: Returns the highlight group used by vim-signify depending on
  "              how the line was edited. Called by vim-signature.
  call sy#sign#get_current_signs()
  if has_key(b:sy.internal, a:lineno)
    let type = b:sy.internal[a:lineno]['type']
    if type =~ 'SignifyAdd'
      return 'DiffAdd'
    elseif type =~ 'SignifyChange'
      return 'DiffChange'
    elseif type =~ 'SignifyDelete'
      return 'DiffDelete'
    end
  else
    return 'LineNr'
  endif
endfunction

function! RKPatchInactiveColors(palette)
  if g:airline_theme == 'powerlineish'
    for colors in values(a:palette.inactive)
      let colors[0] = '#9e9e9e'
      let colors[2] = 247
    endfor
  endif
endfunction

" Begin Vundle setup
filetype off
set runtimepath+=$HOME/.vim/bundle/vundle
call vundle#rc()

Plugin 'gmarik/vundle'

" Status line enhancement
Plugin 'bling/vim-airline'
" This refers to an environment variable set (or not) during login. We set it
" when logging in by phone because the ConnectBot app doesn't support fonts
" required for Powerline.
if $NO_POWERLINE_FONTS == 1
	let g:airline_powerline_fonts=0
else
	let g:airline_powerline_fonts=1
endif
let g:airline_theme='powerlineish'
let g:airline_theme_patch_func = 'RKPatchInactiveColors'
let g:airline#extensions#whitespace#mixed_indent_algo=1
" Change words to other variants
Plugin 'tpope/vim-abolish'
" Base16 color scheme
Plugin 'chriskempson/base16-vim'
let base16colorspace=256
" Delphi syntax highlighting
Plugin 'rkennedy/vim-delphi'
" Handle Git files
Plugin 'tpope/vim-git'
" Show changed lines in gutter
Plugin 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'cvs']
let g:signify_vcs_cmds = { 'cvs': 'cvs -d '.$CVSROOT.' diff -U0 -- %f' }
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
Plugin 'tmux-plugins/vim-tmux'
" Operate Git within Vim
Plugin 'tpope/vim-fugitive'
" Detect and apply indentation settings
Plugin 'tpope/vim-sleuth'
" Python indentation settings
Plugin 'hynek/vim-python-pep8-indent'
" Run Ack within Vim
Plugin 'mileszs/ack.vim'
" Run builds asynchronously within Vim
Plugin 'tpope/vim-dispatch'
" Display marks in sign column
Plugin 'kshenoy/vim-signature'
let g:SignatureMarkTextHL = function('RKGetSignifyHLGroup')

" NOTE: Also check for local .vimrc file
" End Vundle setup

set guifont=Sauce\ Code\ Powerline:h10
syntax on
set foldcolumn=2 " left columns for code-folding indicators
set guioptions-=T " disable tool bar
set hlsearch " highlight all search results

" Options to better see where we are
set number
set relativenumber
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
set nojoinspaces " no extra space between sentences joined from multiple lines

" If Vim supports persistent undo, then determine the platform-appropriate
" directory and store undo files there.
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

colorscheme base16-bright
" The default base16-bright scheme sets Search to an unreadable combination
" and sets the background of DiffChange inconsistently with vim-signify.
hi Search ctermfg=18 ctermbg=11
hi DiffChange ctermfg=04 ctermbg=18

silent! source $HOME/dotfiles.local/vimrc
