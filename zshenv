: ${DOTFILES:=${${(%):-%x}:A:h}}
: ${DOTFILES_LOCAL:=${HOME}/dotfiles.local}
export DOTFILES DOTFILES_LOCAL

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

# This variable would tell zsh to read system-wide config files like
# /etc/zprofile and /etc/zshrc. We don't want those because they make unwanted
# changes to variables like PATH and MANPATH.
unsetopt GLOBAL_RCS

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

export PIPX_HOME=${PLAT_PATH}/pipx
export PIPX_BIN_DIR=${PLAT_PATH}/bin

# This is the default value. We duplicate it here to mirror .gitconfig settings.
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

#BASH_COMPLETION=$HOME/etc/bash_completion
#[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

PATH=$(${DOTFILES}/bin/generate-path "${PATH}" "${DOTFILES}/PATHrc")
export PATH
MANPATH=$(${DOTFILES}/bin/generate-path "${MANPATH}" "${DOTFILES}/MANPATHrc")
export MANPATH

# Set this via environment variable to allow overriding in DOTFILES_LOCAL.
export ATUIN_SYNC_ADDRESS='https://atuin.goblin-grue.ts.net'

umask 022

[[ -r ${DOTFILES_LOCAL}/zshenv ]] && source ${DOTFILES_LOCAL}/zshenv
