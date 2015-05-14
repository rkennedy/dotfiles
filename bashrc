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

alias cr='PAGER=cat /net/code/ovsrc/int/tools/bin/cvs_review'

type dircolors >/dev/null 2>&1 && {
	eval `dircolors -b $DOTFILES/dir_colors`
}

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

# Put screen session name and window number in prompt
[[ -n $STY ]] && screen="$(echo $STY | sed 's/^[0-9]\{1,\}\.//; s/\..*$//'):$WINDOW "
# current directory in green. On next line, hostname and history number
PS1='[$screen\[\e[0;32m\]\w\[\e[0m\]]\n\h [\!]\$ '

# Use logical directory paths for cd instead of physical.
set +o physical
# Delay job-completion notification until printing of next prompt
set +o notify

shopt -s autocd extglob force_fignore no_empty_cmd_completion nocaseglob
shopt -u sourcepath
shopt -s checkwinsize

source $DOTFILES/functions.sh

[[ -r $HOME/.bashrc.local ]] && source $HOME/.bashrc.local
