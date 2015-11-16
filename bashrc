# ~/.bashrc: executed by bash(1) for non-login shells, and by .bash_profile
# for login shells.
# Set environment variables in .bash_profile and .cshrc.

[[ -z ${DOTFILES:+x} ]] && export DOTFILES="$(dirname "$(perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${BASH_SOURCE[0]}")")"

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

# Allow quick switching to zsh
if type -Pf zsh >/dev/null 2>&1; then
  alias z='export SHELL=`type -Pf zsh`; exec $SHELL -l'
else
  alias z='echo no zsh available'
fi

# We usually set environment variables like this in .bash_profile, but it can
# affect non-interactive invocations of grep, so we set it here instead.
export GREP_OPTIONS=--color=auto

source $DOTFILES/path_funcs.sh

# Even when not interactive, we want access to local programs,
# especially git
[[ $- == *i* ]] || rk_path_prepend $HOME/.local/bin

HISTSIZE=100
HISTCONTROL=erasedups
FIGNORE='.o:~:.rpo:.class'
unset MAILCHECK IGNOREEOF CDPATH HISTFILE

# current directory in green. On next line, hostname and history number
PS1='[\[\e[0;32m\]\w\[\e[0m\]]\n\h [\!]\$ '

# Use logical directory paths for cd instead of physical.
set +o physical
# Delay job-completion notification until printing of next prompt
set +o notify

shopt -s force_fignore
shopt -s no_empty_cmd_completion
shopt -u autocd
shopt -u sourcepath
shopt -s checkwinsize

[[ -r $HOME/.bashrc.local ]] && source $HOME/.bashrc.local
