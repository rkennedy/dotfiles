# This file is run for interactive login shells.

# Set environment variables here. If bash is not the login shell, then
# be sure to also make corresponding environment settings in .cshrc.

[[ -z ${DOTFILES:+x} ]] && export DOTFILES="$(dirname "$(perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${BASH_SOURCE[0]}")")"

source $DOTFILES/path_funcs.sh

rk_path_prepend $HOME/.local/lib LD_LIBRARY_PATH
rk_path_prepend $HOME/.local/include C_INCLUDE_PATH
rk_path_prepend $HOME/.local/include CPLUS_INCLUDE_PATH
rk_path_prepend $HOME/.local/lib LIBRARY_PATH

export LC_COLLATE='C'
export LANG='en_US.UTF-8'

# Git uses this to request passwords, but fails when there's no X server, so
# let's disable it.
unset SSH_ASKPASS

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

# This is the default value. We duplicate it here to mirror .gitconfig settings.
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

BASH_COMPLETION=$HOME/etc/bash_completion
[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

rk_path_import PATH $DOTFILES/PATHrc
rk_path_import MANPATH $DOTFILES/MANPATHrc

if type pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

umask 022

source $DOTFILES/functions.sh

: ${COLORFGBG:='15;1'}

[[ -r $HOME/.bash_profile.local ]] && source $HOME/.bash_profile.local

update_color

# Source the file that's executed for interactive non-login shells.
[[ -r $HOME/.bashrc ]] && source $HOME/.bashrc

# vim: set ft=sh:
