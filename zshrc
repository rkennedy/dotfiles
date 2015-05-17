# Settings for interactive shell go here.

[[ -z ${DOTFILES:+x} ]] && export DOTFILES="$(dirname "$(perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${(%):-%x}")")"

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

# We usually set environment variables like this in .zshenv, but it can affect
# non-interactive invocations of grep, so we set it here instead.
export GREP_OPTIONS=--color=auto

HISTSIZE=100
setopt hist_ignore_all_dups
fignore=(.o ~ .rpo .class)
unset MAILCHECK IGNOREEOF CDPATH HISTFILE

# current directory in green. On next line, hostname and history number
PS1=$'[%F{green}%~%f]\n%m [%!]%(!.#.$) '

# Delay job-completion notification until printing of next prompt
setopt nonotify
setopt auto_cd
#setopt force_fignore  # Not in zsh
#setopt checkwinsize  # Not in zsh

source $DOTFILES/functions.sh

[[ -r $HOME/.zshrc.local ]] && source $HOME/.zshrc.local