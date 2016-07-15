" Don't show the current mode; it's already shown on the status line.
set noshowmode

function! RKStatusLineCurLine()
  return ($NO_POWERLINE_FONTS ? "" : "") . printf('%*d', len(line('$')), line('.'))
endfunction

let s:modes = {
  \ 'n': { 'text': 'N', 'modifier': 'n' },
  \ 'i': { 'text': 'I', 'modifier': 'i' },
  \ 'R': { 'text': 'R', 'modifier': 'r' },
  \ 'v': { 'text': 'V', 'modifier': 'v' },
  \ 'V': { 'text': 'VL', 'modifier': 'v' },
  \ '': { 'text': 'VB', 'modifier': 'v' },
  \ 's': { 'text': 'S', 'modifier': 'n' },
  \ 'S': { 'text': 'SL', 'modifier': 'n' },
  \ '^S': { 'text': 'SB', 'modifier': 'n' },
  \ 'c': { 'text': 'C', 'modifier': 'n' },
\ }

if $NO_POWERLINE_FONTS
  let s:separators = {
    \ 'solid': {
      \ 'left': '',
      \ 'right': '',
    \ },
    \ 'open' : {
      \ 'left': '',
      \ 'right': '',
    \ }
  \ }
else
  let s:separators = {
    \ 'solid': {
      \ 'left': '',
      \ 'right': '',
    \ },
    \ 'open' : {
      \ 'left': '',
      \ 'right': '',
    \ }
  \ }
endif

function! RKStatusLineMode(winnum)
  let l:active = a:winnum == winnr()
  let l:bufnum = winbufnr(a:winnum)

  if l:active
    let l:leftsep = $NO_POWERLINE_FONTS ? '' : ''
    let l:rightsep = $NO_POWERLINE_FONTS ? '' : ''
  else
    let l:leftsep = $NO_POWERLINE_FONTS ? '' : ''
    let l:rightsep = $NO_POWERLINE_FONTS ? '' : ''
  endif

  let l:left1 = ' %-2(' . get(s:modes, mode(), {'text':'<' . mode() . '>'}).text . '%) '
  let l:left1 = l:left1 . '%{ &paste ? '' PASTE '' : '''' }'
  let l:left1 = l:left1 . '%{ &spell ? '' SPELL '' : '''' }'

  let l:left3 = ' %(±%{fugitive#head(7)}%{ $NO_POWERLINE_FONTS ? "\\" : "  " }%)'
  let l:left3 = l:left3 . '%{ &readonly ? "○": "●" } '

  let l:right1 = ' %3p%% '
  let l:right1 = l:right1 . '%{RKStatusLineCurLine()}/%L '
  let l:right1 = l:right1 . '%3c| '

  let l:right2 = ' %{&fenc . ($NO_POWERLINE_FONTS ? "/" : "  ") . &ff} '

  let l:right3 = ' %{&ft} '

  let l:main = ' %f %m%='

  if l:active
    let l:modifier = get(s:modes, mode(), {'modifier': 'n'}).modifier
    let l:color1 = printf('StatusLine1%s', l:modifier)
    let l:color2 = printf('StatusLine2%s', l:modifier)
    let l:color3 = printf('StatusLine3%s', l:modifier)
    let l:color1_2 = printf('StatusLine1_2%s', l:modifier)
    let l:color1_3 = printf('StatusLine1_3%s', l:modifier)
    let l:color1_4 = printf('StatusLine1_4%s', l:modifier)
    let l:color2_3 = printf('StatusLine2_3%s', l:modifier)
    let l:color3_4 = printf('StatusLine3_4%s', l:modifier)
    let l:result = '%#' . l:color1 . '#' . l:left1
    if len(l:left3) > 0
      let l:result = l:result . '%#' . l:color1_3 . '#' . l:leftsep . '%#' . l:color3 . '#' . l:left3 . '%#' . l:color3_4 . '#'
    else
      let l:result = l:result . '%#' . l:color1_4 . '#'
    endif
    let l:result = l:result . l:leftsep . '%*' . l:main . '%#' . l:color3_4 . '#' . l:rightsep . '%#' . l:color3 . '#' . l:right3 . '%#' . l:color2_3 . '#' . l:rightsep . '%#' . l:color2 . '#' . l:right2 . '%#' . l:color1_2 . '#' . l:rightsep . '%#' . l:color1 . '#' . l:right1 . '%*'
  else
    let l:result = l:left1
    if len(l:left3) > 0
      let l:result = l:result . l:leftsep . l:left3
    endif
    let l:result = l:result . l:leftsep . l:main . l:rightsep . l:right3 . l:rightsep . l:right2 . l:rightsep . l:right1
  endif
  return l:result
endfunction

function! s:RefreshStatus()
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!RKStatusLineMode(' . nr . ')')
  endfor
endfunction

augroup status
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
augroup END

set laststatus=2  " always show status bar

function s:set_up_status_colors()
  " TODO: Inactive vs. active statusline
  let l:colors={
    \ 'n': [{'bg': 148, 'fg': 22}, {'bg': 19, 'fg': 20}, {'bg': 236, 'fg': 247}, {'bg': 233}],
    \ 'i': [{'bg': 231, 'fg': 23}, {'bg': 31, 'fg': 74}, {'bg': 24, 'fg': 117}],
    \ 'r': [{'bg': 160, 'fg': 231}],
    \ 'v': [{'bg': 214, 'fg': 232}],
  \ }

  let l:cmd = printf(':highlight StatusLine ctermfg=231 ctermbg=%d', l:colors['n'][3].bg)
  exec l:cmd
  let l:cmd = printf(':highlight StatusLineNC ctermfg=247 ctermbg=%d', l:colors['n'][3].bg)
  exec l:cmd

  for M in ['n', 'i', 'r', 'v']
    " First mode style
    let l:label = printf('StatusLine1x%s', M)
    let l:cmd = printf(':highlight %s ctermfg=%d ctermbg=%d cterm=bold', l:label, l:colors[M][0].fg, l:colors[M][0].bg)
    exec l:cmd

    " Mode styles per level
    for L in [1, 2, 3]
      let l:label = printf('StatusLine%d%s', L, M)
      if L - 1 < len(l:colors[M])
        let l:cmd = printf(':highlight %s ctermfg=%d ctermbg=%d', l:label, l:colors[M][L-1].fg, l:colors[M][L-1].bg)
      else
        let l:firstlabel = printf('StatusLine%d%s', L, 'n')
        let l:cmd = printf(':highlight link %s %s', l:label, l:firstlabel)
      endif
      exec l:cmd
    endfor

    " Mode style level transitions
    for L1 in [1, 2, 3]
      let L2 = L1+1
      while L2 <= 4
        let l:label = printf('StatusLine%d_%d%s', L1, L2, M)
        let l:bg1 = get(l:colors[M], L1-1, l:colors['n'][L1-1]).bg
        let l:bg2 = get(l:colors[M], L2-1, l:colors['n'][L2-1]).bg
        let l:cmd = printf(':highlight %s ctermfg=%d ctermbg=%d', l:label, l:bg1, l:bg2)
        exec l:cmd
	let L2 = L2+1
      endwhile
    endfor
  endfor
endfunction

call s:set_up_status_colors()

" vim: set sw=2 et:
