# This file is run for interactive login shells.

# Set environment variables here. If bash is not the login shell, then
# be sure to also make corresponding environment settings in .cshrc.

source $HOME/dotfiles/path_funcs.sh

rk_path_prepend $HOME/.local/lib LD_LIBRARY_PATH
rk_path_prepend $HOME/.local/include C_INCLUDE_PATH
rk_path_prepend $HOME/.local/include CPLUS_INCLUDE_PATH
rk_path_prepend $HOME/.local/lib LIBRARY_PATH

export LC_COLATE='C'

export EDITOR='vim'
export VISUAL='gvim'
export PAGER='less'
export LESS='-MqSX -x2'
export LESSOPEN='| bash ~/dotfiles/Lesspipe/lesspipe.sh %s'

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

while read item
do
	rk_path_append $item PATH
done < <(source $HOME/.PATHrc | sort -n | cut '-d ' -s -f 2-)

[ -r $HOME/.bash_profile.local ] && source $HOME/.bash_profile.local

case $(hostname) in
	coachwood )
		umask 002
		;;
	*)
		umask 022
esac

# Source the file that's executed for interactive non-login shells.
[[ -r $HOME/.bashrc ]] && source $HOME/.bashrc

# vim: set ft=sh:
