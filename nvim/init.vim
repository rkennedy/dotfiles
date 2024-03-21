" Begin plug-in setup
filetype off

" embear/vim-localvimrc
let g:localvimrc_name = ['_vimrc_local.vim']
let g:localvimrc_persistence_file = stdpath('state') . '/localvimrc_persistent'
let g:localvimrc_whitelist = [
      \ '/export/rkennedy/src',
      \ '/data/rkennedy/src',
      \ '/home/rkennedy/src/catreader',
      \ '/home/rkennedy/work/src',
      \ '/home/rkennedy/dotfiles',
      \]
let g:localvimrc_persistent = 2

" End plug-in setup

syntax on
set foldcolumn=2 " left columns for code-folding indicators
set hlsearch " highlight all search results

" Wait forever for compound commands
set notimeout

" Options to better see where we are
set number
set relativenumber
set colorcolumn=80 " highlight column 80
augroup quickfix_colors
  autocmd!
  autocmd FileType qf setlocal colorcolumn=
augroup END
set cursorline
set showcmd

set formatoptions+=r " automatically insert comment-continuation char
set formatoptions-=o " Don't continue comments after pressing O or o.
set formatoptions+=j " Remove comment leader when joining lines
set formatoptions+=n " Use hanging indents in lists.
set nojoinspaces " no extra space between sentences joined from multiple lines

set cinoptions+=l1 " align code under case label, not brace
set cinoptions+=t0 " don't indent function return type
set cinoptions+=(0 " align with unclosed parenthesis ...
set cinoptions+=W4 " ... unless it's at the end of a line
set cinoptions+=g0 " align C++ visibility with the enclosing block
set cinoptions+=:0 " align case labels with enclosing switch block

set undofile

" Disable mouse support
set mouse=

" Open new windows below (:new) or right (:vnew) of the current window
set splitbelow splitright

" markdown
let g:markdown_recommended_style = 1
let g:markdown_fenced_languages = ["c++=cpp", 'python', 'bash=sh']
let g:markdown_syntax_conceal = 1

filetype plugin indent on

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

set tags^=.git/tags;

" vim: set ts=2 sw=2 et:
