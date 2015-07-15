if ls --color=auto 2>/dev/null >/dev/null; then
	alias ls='ls -obF --color'
else
	alias ls='ls -obF'
fi
alias la='ls -a'
alias rm='rm -i' cp='cp -i' mv='mv -i'
alias which='type -p'

alias ps='ps -o "pid tty user time args"'

type dircolors >/dev/null 2>&1 && {
	eval `dircolors -b $DOTFILES/dir_colors`
}

# Allow quick switching to bash
if whence -p bash >/dev/null 2>&1; then
    alias b='export SHELL=`whence -p bash`; exec $SHELL -l'
else
    alias b='echo no bash available'
fi

HISTSIZE=100
setopt hist_ignore_all_dups
fignore=(.o ~ .rpo .class)
unset MAILCHECK IGNOREEOF CDPATH HISTFILE

# current directory in green. On next line, hostname and history number
PS1=$'[%F{green}%~%f]\n%m [%!]%(!.#.$) '

# Delay job-completion notification until printing of next prompt
setopt nonotify

unsetopt auto_cd
