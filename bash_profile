# This file is run for interactive login shells.

# Set environment variables here. If bash is not the login shell, then
# be sure to also make corresponding environment settings in .cshrc.

: ${DOTFILES:=$(dirname "$(perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${BASH_SOURCE[0]}")")}
: ${DOTFILES_LOCAL:=${HOME}/dotfiles.local}
export DOTFILES DOTFILES_LOCAL

source $DOTFILES/path_funcs.sh

rk_path_prepend $HOME/.local/lib LD_LIBRARY_PATH
rk_path_prepend $HOME/.local/include C_INCLUDE_PATH
rk_path_prepend $HOME/.local/include CPLUS_INCLUDE_PATH
rk_path_prepend $HOME/.local/lib LIBRARY_PATH

export LC_COLLATE='C'
if locale -a | grep -F en_US.UTF-8 >/dev/null; then
    export LANG='en_US.UTF-8'
fi

# Git uses this to request passwords, but fails when there's no X server, so
# let's disable it.
unset SSH_ASKPASS

export EDITOR='vim'
export SUDO_EDITOR='vim'
export VISUAL='gvim'
export PAGER='less'
export LESS='-MqSX -x2'
export LESSOPEN='| bash $DOTFILES/Lesspipe/lesspipe.sh %s'
export LESSCOLORIZER='pygmentize -O style=rrt'
export LESSCOLOR=always

# I often don't have write permission for files Cscope finds, so don't
# try to open them for writing.
export CSCOPE_EDITOR='view'

# Settings for cvs
export CVSEDITOR='vim'
export CVSREAD='Yes'

export PYTHONSTARTUP=$DOTFILES/python-shell-enhancement/pythonstartup.py

export PLAT_PATH=$HOME/.local/$(uname -s)/$(uname -m)
if [ -e ${PLAT_PATH}/go ]; then
    export GOROOT=${PLAT_PATH}/go
    export GOBIN=${PLAT_PATH}/bin
fi

# This is the default value. We duplicate it here to mirror .gitconfig settings.
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

BASH_COMPLETION=$HOME/etc/bash_completion
[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

PATH=$(${DOTFILES}/bin/generate-path "${PATH}" "${DOTFILES}/PATHrc")
export PATH
MANPATH=$(${DOTFILES}/bin/generate-path "${MANPATH}" "${DOTFILES}/MANPATHrc")
export MANPATH

umask 022

source $DOTFILES/functions.sh

: ${COLORFGBG:='15;1'}

[[ -r ${DOTFILES_LOCAL}/bash_profile ]] && source ${DOTFILES_LOCAL}/bash_profile

update_color

# Source the file that's executed for interactive non-login shells.
[[ -r $HOME/.bashrc ]] && source $HOME/.bashrc

# vim: set ft=sh:
