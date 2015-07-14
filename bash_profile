# This file is run for interactive login shells.

# Set environment variables here. If bash is not the login shell, then
# be sure to also make corresponding environment settings in .cshrc.

[[ -z ${DOTFILES:+x} ]] && export DOTFILES="$(dirname "$(perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${BASH_SOURCE[0]}")")"

source $DOTFILES/path_funcs.sh

rk_path_prepend $HOME/.local/lib LD_LIBRARY_PATH
rk_path_prepend $HOME/.local/include C_INCLUDE_PATH
rk_path_prepend $HOME/.local/include CPLUS_INCLUDE_PATH
rk_path_prepend $HOME/.local/lib LIBRARY_PATH

export LC_COLATE='C'

export EDITOR='vim'
export VISUAL='gvim'
export PAGER='less'
export LESS='-MqSX -x2'
export LESSOPEN='| bash $DOTFILES/Lesspipe/lesspipe.sh %s'

# I often don't have write permission for files Cscope finds, so don't
# try to open them for writing.
export CSCOPE_EDITOR='view'

# Settings for cvs
export CVSEDITOR='vim'
export CVSREAD='Yes'

export PYENV_ROOT=$DOTFILES/pyenv
export PYTHONSTARTUP=$DOTFILES/python-shell-enhancement/pythonstartup.py

BASH_COMPLETION=$HOME/etc/bash_completion
[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

rk_path_import PATH $DOTFILES/PATHrc
rk_path_import MANPATH $DOTFILES/MANPATHrc

eval "$(pyenv init -)"

umask 022

[[ -r $HOME/.bash_profile.local ]] && source $HOME/.bash_profile.local

# Source the file that's executed for interactive non-login shells.
[[ -r $HOME/.bashrc ]] && source $HOME/.bashrc

# vim: set ft=sh:
