: ${DOTFILES:=${${(%):-%x}:A:h}}
export DOTFILES

typeset -U -T LD_LIBRARY_PATH ld_library_path
ld_library_path=($HOME/.local/lib ${(@)ld_library_path})
typeset -U -T C_INCLUDE_PATH c_include_path
c_include_path=($HOME/.local/include ${(@)c_include_path})
typeset -U -T CPLUS_INCLUDE_PATH cplus_include_path
cplus_include_path=($HOME/.local/include ${(@)cplus_include_path})
typeset -U -T LIBRARY_PATH library_path
library_path=($HOME/.local/lib ${(@)library_path})

export LC_COLLATE='C'
if locale -a | grep -F en_US.UTF-8 >/dev/null; then
    export LANG='en_US.UTF-8'
fi

# Git uses this to request passwords, but fails when there's no X server, so
# let's disable it. Note that this might get re-set during execution of
# /etc/zshrc, so we may have to undo this again
unset SSH_ASKPASS

export EDITOR='vim'
export SUDO_EDITOR='vim'
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

export PYTHONSTARTUP=$DOTFILES/python-shell-enhancement/pythonstartup.py

# This is the default value. We duplicate it here to mirror .gitconfig settings.
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

#BASH_COMPLETION=$HOME/etc/bash_completion
#[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

PATH=$(${DOTFILES}/bin/generate-path "${PATH}" "${DOTFILES}/PATHrc")
export PATH
MANPATH=$(${DOTFILES}/bin/generate-path "${MANPATH}" "${DOTFILES}/MANPATHrc")
export MANPATH

umask 022

[[ -r $HOME/.zshenv.local ]] && source $HOME/.zshenv.local
