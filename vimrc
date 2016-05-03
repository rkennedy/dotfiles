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

" Begin plug-in setup
filetype off

set runtimepath+=$DOTFILES/vim-bundle/vim-pathogen
execute pathogen#infect("$DOTFILES/vim-bundle/{}")

" vim-airline/vim-airline
" vim-airline/vim-airline-themes
" This refers to an environment variable set (or not) during login. We set it
" when logging in by phone because the ConnectBot app doesn't support fonts
" required for Powerline.
let g:airline_powerline_fonts=!($NO_POWERLINE_FONTS == 1)
let g:airline_theme='powerlineish'
let g:airline_theme_patch_func = 'RKPatchInactiveColors'
let g:airline#extensions#whitespace#mixed_indent_algo=1

" chriskempson/base16-vim
let base16colorspace=256

" mhinz/vim-signify
let g:signify_vcs_list = ['git', 'cvs']
let g:signify_vcs_cmds = { 'cvs': 'cvs -d '.$CVSROOT.' diff -U0 -- %f' }

" mileszs/ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ack_use_dispatch = 1

" kshenoy/vim-signature
let g:SignatureMarkTextHL = function('RKGetSignifyHLGroup')

" NOTE: Also check for local .vimrc file
silent! source $HOME/dotfiles.local/vimrc
" End plug-in setup

set guifont=Sauce\ Code\ Powerline:h10
syntax on
set foldcolumn=2 " left columns for code-folding indicators
set guioptions-=T " disable tool bar
set hlsearch " highlight all search results

" Options to better see where we are
set number
set relativenumber
set colorcolumn=80 " highlight column 80
set cursorline

" Don't show the current mode; it's already shown by Airline.
set noshowmode

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

