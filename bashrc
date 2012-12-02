# ~/.bashrc: executed by bash(1) for non-login shells.
# Set environment variables in .cshrc

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

case $(hostname) in
	mageddon | stanton )
		export PERLBREW_HOME=~/.perlbrew/$(hostname)
esac
export PERLBREW_ROOT=/usr/local
[ -r $PERLBREW_ROOT/etc/bashrc ] && source $PERLBREW_ROOT/etc/bashrc

eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)

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

evcd() {
    if [[ x$3 == x ]]; then
        evidence=/net/${1}spt/evidence/$1
    else
        evidence=/net/$3/evidence/$1
    fi
	titan='([[:digit:]]{3})-?([[:digit:]]{3})-?([[:digit:]]([[:digit:]]{2}))';
	etrack='([eE][tT])?([[:digit:]]{7})';
	sfdc='[[:digit:]]{8}'
	if [[ $2 =~ $sfdc ]]; then
		dir=$evidence/${2:6:8}/$2
		echo cd $dir
		cd $dir
	elif [[ $2 =~ $titan ]]; then
		dir=$evidence/${BASH_REMATCH[4]}/${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-${BASH_REMATCH[3]};
		echo cd $dir;
		cd $dir;
	elif [[ $2 =~ $etrack ]]; then
		echo $etrack;
		caseno=$(extrefs ${BASH_REMATCH[2]} | head -1);
		if [[ $? ]]; then
			evcd $1 $caseno $3
		fi
	fi
}
rosspt() { evcd ros $1 ross550/vol/exports; }
sprspt() { evcd spr $1; }
sydspt() { evcd syd $1; }
rdgspt() { evcd rdg $1; }
hrospt() { evcd hro $1 hro-evidence.spr.spt.symantec.com/c; }
punspt() { evcd pun $1; }

nmakeall() {
	for plat in x86 AMD64 IA64; do
		nmake -t y -a $plat "$@"
	done
}
makeall() {
	/usr/bin/make TrustLibs=yes "$@"
	nmakeall
}
m() {
	case "${1:-all}" in
	'x86'|'AMD64'|'IA64')
		nmake -t y -a "$1" "${@:2}"
		;;
	'all')
		makeall "${@:2}"
		;;
	*)
		/usr/bin/make TrustLibs=yes P="$1" "${@:2}"
	esac
}
cvs_up() {
	find ${@:-.} -type d -name CVS -prune \
		| sed 's/\/CVS//' \
		| xargs cvs up -l \
		| grep -v -E '^\?'
}
cvs_diff() {
	cvs diff -up "$@" \
		| grep -v -E '^\?' \
		| colordiff \
		| less -RF
}

export GREP_OPTIONS=--color=auto

..() {
	cd ..
}

rehash() {
	hash -r
}

pretty() {
	pygmentize -g -f terminal256 -O bg=dark "$@" \
	| $PAGER -RF
}
