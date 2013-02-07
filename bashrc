# ~/.bashrc: executed by bash(1) for non-login shells.
# Set environment variables in .cshrc

eval `~/.local/bin/setpaths.pl --sh`

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

if [ -x $PLATFORM_BIN/dircolors ]; then
	eval `$PLATFORM_BIN/dircolors -b ~/.dir_colors`
fi

HISTSIZE=100
HISTCONTROL=erasedups
FIGNORE='.o:~:.rpo:.class'
unset MAILCHECK IGNOREEOF CDPATH HISTFILE

# Put screen session name and window number in prompt
[ -n "$STY" ] && screen="$(echo $STY | sed 's/^[0-9]\{1,\}\.//; s/\..*$//'):$WINDOW "
# current directory in green. On next line, hostname and history number
PS1='[\[$screen\e[0;32m\]\w\[\e[0m\]]\n\h [\!]\$ '

# Use logical directory paths for cd instead of physical.
set +o physical
# Delay job-completion notification until printing of next prompt
set +o notify

shopt -s autocd extglob force_fignore no_empty_cmd_completion nocaseglob
shopt -u sourcepath
shopt -s checkwinsize

export LC_COLATE=C
export CVSREAD=Yes
export PAGER=less
export LESS='-MqSX -x2'
export EDITOR=vim
export CSCOPE_EDITOR=view
export VISUAL=gvim
export CVSEDITOR=vim
export CVS_REVIEW_MODE='Graph diff'
export REVIEW_VIEWER=vim
export DIFF='diff -up'

BASH_COMPLETION=$HOME/etc/bash_completion
[ -r $BASH_COMPLETION ] && source $BASH_COMPLETION

source ~/perl5/perlbrew/etc/bashrc

# Ctrl+Up and Ctrl+Down search history based on current command prefix
bind '"\eOA":history-search-backward'
bind '"\eOB":history-search-forward'
# Home and End
bind '"\e[1~":beginning-of-line'
bind '"\e[4~":end-of-line'
# Delete
bind '"\e[3~":delete-char'
# Ctrl+Left and Ctrl+Right navigate forward and backward words
bind '"\eOD":backward-word'
bind '"\eOC":forward-word'

source ~/dotfiles/functions.sh
