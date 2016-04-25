: ${DOTFILES:=${${(%):-%x}:A:h}}

typeset -U -T LD_LIBRARY_PATH ld_library_path
ld_library_path=($HOME/.local/lib ${(@)ld_library_path})
typeset -U -T C_INCLUDE_PATH c_include_path
c_include_path=($HOME/.local/include ${(@)c_include_path})
typeset -U -T CPLUS_INCLUDE_PATH cplus_include_path
cplus_include_path=($HOME/.local/include ${(@)cplus_include_path})
typeset -U -T LIBRARY_PATH library_path
library_path=($HOME/.local/lib ${(@)library_path})

export LC_COLLATE='C'

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

#BASH_COMPLETION=$HOME/etc/bash_completion
#[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

paths=("${(@f)$(source $DOTFILES/PATHrc | sort -n | cut '-d ' -s -f 2-)}")
path=(${path:|paths} ${(u)paths})
unset paths

typeset -T -U DEFAULT_MANPATH=$(env MANPATH= man --path) default_manpath
typeset -T -U PATHS=$(source $DOTFILES/MANPATHrc | sort -n | cut -d' ' -s -f 2- | paste -sd : -) paths
manpath=(${manpath:|paths} ${(u)paths} ${default_manpath:|manpath})
typeset -U MANPATH
unset DEFAULT_MANPATH default_manpath paths

if type pyenv >&/dev/null; then
    eval "$(pyenv init -)"
fi

umask 022

[[ -r $HOME/.zshenv.local ]] && source $HOME/.zshenv.local
