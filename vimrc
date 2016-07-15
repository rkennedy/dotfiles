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

" Begin plug-in setup
filetype off

set runtimepath+=$DOTFILES/vim-bundle/vim-pathogen
execute pathogen#infect("$DOTFILES/vim-bundle/{}")

" chriskempson/base16-vim
let base16colorspace=256

" mhinz/vim-signify
let g:signify_vcs_list = ['git', 'cvs']
let g:signify_vcs_cmds = { 'cvs': 'cvs -d '.$CVSROOT.' diff -U0 -- %f' }
let g:signify_sign_change = '±'

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
if has('folding')
  set foldcolumn=2 " left columns for code-folding indicators
endif
set guioptions-=T " disable tool bar
if has('extra_search')
  set hlsearch " highlight all search results
endif

" Options to better see where we are
set number
if exists('+relativenumber')
  set relativenumber
endif
if has('syntax')
  set colorcolumn=80 " highlight column 80
  set cursorline
endif
if has('cmdline_info')
  set showcmd
endif

" Don't try to connect to X server for clipboard support; it's unlikely
" the X server on my systems will be active.
if has('xterm_clipboard')
  set clipboard=exclude:.*
endif

"set listchars=nbsp:␣,eol:¶,trail:·,tab:▶‣

set formatoptions+=r " automatically insert comment-continuation char
set formatoptions-=o " Don't continue comments after pressing O or o.
set formatoptions+=j " Remove comment leader when joining lines
set nojoinspaces " no extra space between sentences joined from multiple lines

if has('cindent')
  set cinoptions+=l1 " align code under case label, not brace
  set cinoptions+=t0 " don't indent function return type
  set cinoptions+=(0 " align with unclosed parenthesis ...
  set cinoptions+=W4 " ... unless it's at the end of a line
  set cinoptions+=g0 " align C++ visibility with the enclosing block
endif

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

if has('syntax')
  colorscheme base16-bright
  " The default base16-bright scheme sets Search to an unreadable combination
  " and sets the background of DiffChange inconsistently with vim-signify.
  hi Search ctermfg=18 ctermbg=11
  hi DiffChange ctermfg=04 ctermbg=18
endif

source $DOTFILES/vim-statusline.vim

" vim: set sw=2 et:
