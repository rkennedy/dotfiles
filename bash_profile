# This file is run for interactive login shells.

# Set environment variables here. If bash is not the login shell, then
# be sure to also make corresponding environment settings in .cshrc.

export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$HOME/.local/include
export CPLUS_INCLUDE_PATH=$HOME/.local/include
export LIBRARY_PATH=$HOME/.local/lib

export LC_COLATE='C'

export EDITOR='vim'
export VISUAL='gvim'
export PAGER='less'
export LESS='-MqSX -x2'
export LESSOPEN='| bash ~/dotfiles/Lesspipe/lesspip.sh %s'

# I often don't have write permission for files Cscope finds, so don't
# try to open them for writing.
export CSCOPE_EDITOR='view'

# Settings for cvs
export CVSEDITOR='vim'
export CVSREAD='Yes'

# Settings for cvs_review
export CVS_REVIEW_MODE='Diff'
export DIFF='diff -up'
export REVIEW_VIEWER='vim'

# Make Vim detect computers that use the dark Solarized color scheme
# rather than the light one.
export COLORFGBG='15;0'

export PYTHONSTARTUP=$HOME/dotfiles/python-shell-enhancement/pythonstartup.py

BASH_COMPLETION=$HOME/etc/bash_completion

PERLBREWRC=$HOME/perl5/perlbrew/etc/bashrc

# Search for and remove occurrences of $1 in the environment variable $2. Use
# $3 to compare the items. $2 defaults to PATH; $3 to =. Use =~ for $3 for
# regex comparisons.
rk_path_remove () {
	local IFS=':'
	local NEWPATH
	local DIR
	local PATHVARIABLE=${2:-PATH}
	local OP=${3:-=}
	for DIR in ${!PATHVARIABLE} ; do
		[ "$DIR" $OP "$1" ] || NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
	done
	export $PATHVARIABLE="$NEWPATH"
}

rk_path_prepend () {
	rk_path_remove $1 $2 =
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

rk_path_append () {
	rk_path_remove $1 $2 =
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

while read item
do
	rk_path_prepend $item PATH =
done < <(source $HOME/.PATHrc | sort -rn | cut '-d ' -s -f 2-)

case $(hostname) in
	coachwood )
		umask 002
		;;
	*)
		umask 022
esac

# Source the file that's executed for interactive non-login shells.
[ -r $HOME/.bashrc ] && source $HOME/.bashrc
