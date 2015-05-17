[[ -z ${DOTFILES:+x} ]] && export DOTFILES="$(dirname "$(perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${(%):-%x}")")"

typeset -U -T LD_LIBRARY_PATH ld_library_path
ld_library_path=($HOME/.local/lib ${(@)ld_library_path})
typeset -U -T C_INCLUDE_PATH c_include_path
c_include_path=($HOME/.local/include ${(@)c_include_path})
typeset -U -T CPLUS_INCLUDE_PATH cplus_include_path
cplus_include_path=($HOME/.local/include ${(@)cplus_include_path})
typeset -U -T LIBRARY_PATH library_path
library_path=($HOME/.local/lib ${(@)library_path})

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

# Settings for cvs_review
export CVS_REVIEW_MODE='Diff'
export DIFF='diff -up'
export REVIEW_VIEWER='vim'

# Make Vim detect computers that use the dark Solarized color scheme
# rather than the light one.
export COLORFGBG='15;0'

export PYENV_ROOT=$DOTFILES/pyenv
export PYTHONSTARTUP=$DOTFILES/python-shell-enhancement/pythonstartup.py

#BASH_COMPLETION=$HOME/etc/bash_completion
#[[ -r $BASH_COMPLETION ]] && source $BASH_COMPLETION

path=("${(@f)$(source $DOTFILES/PATHrc | sort -n | cut '-d ' -s -f 2-)}")
manpath=("${(@f)$(source $DOTFILES/MANPATHrc | sort -n | cut '-d ' -s -f 2-)}")

eval "$(pyenv init -)"

[[ -r $HOME/.zshenv.local ]] && source $HOME/.zshenv.local

case $(hostname) in
    coachwood )
        umask 002
        ;;
    *)
        umask 022
esac