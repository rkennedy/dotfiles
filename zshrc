# Settings for interactive shell go in $ZSH_CUSTOM

# Oh My Zsh configuration
export ZSH=$DOTFILES/oh-my-zsh

ZSH_THEME="powerline"

DISABLE_AUTO_UPDATE="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

ZSH_CUSTOM=$DOTFILES/omz-custom
plugins=()
plugins+=(zsh-syntax-highlighting)
ZSH_HIGHLIGHT_HIGHLIGHTERS=()
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main)
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets)
source $ZSH/oh-my-zsh.sh
