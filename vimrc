set nocompatible " not vi-compatible

function RKGetSignifyHLGroup(lineno)
  " Description: Returns the highlight group used by vim-signify depending on
  "              how the line was edited. Called by vim-signature.
  call sy#sign#get_current_signs(b:sy)
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
execute pathogen#infect("$DOTFILES_LOCAL/vim-bundle/{}")

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

" tpope/vim-markdown
let g:markdown_fenced_languages = ["c++=cpp", 'python', 'bash=sh']
let g:markdown_syntax_conceal = 1

" hashivim/vim-terraform
let g:terraform_align = 1
let g:terraform_fold_sections = 1
let g:terraform_remap_spacebar = 1
let g:terraform_commentstring = '//%s'

" LucHermitte/local_vimrc
call lh#local_vimrc#munge('whitelist', '/export/rkennedy/src')
call lh#local_vimrc#munge('whitelist', '/data/rkennedy/src')
call lh#local_vimrc#munge('whitelist', '/home/rkennedy/src/catreader')
call lh#local_vimrc#munge('whitelist', '/home/rkennedy/work/src')

" fatih/vim-go
let g:go_version_warning = 0
let g:go_fmt_experimental = 1
let g:go_fmt_command = 'goimports'

" NOTE: Also check for local .vimrc file
silent! source $DOTFILES_LOCAL/vimrc
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

" Wait forever for compound commands
set notimeout

" Options to better see where we are
set number
if exists('+relativenumber')
  set relativenumber
endif
if has('syntax')
  set colorcolumn=80 " highlight column 80
  augroup quickfix_colors
    autocmd!
    autocmd FileType qf setlocal colorcolumn=
  augroup END
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
set formatoptions+=n " Use hanging indents in lists.
set nojoinspaces " no extra space between sentences joined from multiple lines

if has('cindent')
  set cinoptions+=l1 " align code under case label, not brace
  set cinoptions+=t0 " don't indent function return type
  set cinoptions+=(0 " align with unclosed parenthesis ...
  set cinoptions+=W4 " ... unless it's at the end of a line
  set cinoptions+=g0 " align C++ visibility with the enclosing block
  set cinoptions+=:0 " align case labels with enclosing switch block
endif

" Determine the platform-appropriate directory for storing Vim data
let s:dir = has('win32')
  \ ? '$APPDATA/Vim'
  \ : match(system('uname'), "Darwin") > -1
    \ ? '~/Library/Vim'
    \ : empty($XDG_DATA_HOME)
      \ ? '~/.local/share/vim'
      \ : '$XDG_DATA_HOME/vim'

" If Vim supports persistent undo, then store undo files in s:dir.
if !has('nvim')
  if exists('+undofile')
    let &undodir = expand(s:dir) . '/undo'
    set undofile
  endif
else
  set undofile
endif

" Disable mouse support
set mouse=

" netrw config
let g:netrw_home = expand(s:dir)

" Open new windows below (:new) or right (:vnew) of the current window
set splitbelow splitright

filetype plugin indent on

if has('syntax')
  " The default base16-bright scheme sets Search to an unreadable combination
  " and sets the background of DiffChange inconsistently with vim-signify.
  hi Search ctermfg=18 ctermbg=11
  hi DiffChange ctermfg=04 ctermbg=18
endif

command Wz :write | :suspend

source $DOTFILES/vim-statusline.vim

" Display highlighting settings under cursor position
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" WiX files are XML
augroup wix_ft
  autocmd!
  autocmd BufNewFile,BufRead *.wxs set filetype=xml
augroup END

" Gradle files are Groovy
augroup groovy_ft
  autocmd!
  autocmd BufNewFile,BufRead *.gradle set filetype=groovy
augroup END

set tags^=.git/tags;

" vim: set ts=2 sw=2 et:
