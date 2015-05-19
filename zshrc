# Settings for interactive shell go in $ZSH_CUSTOM

# Oh My Zsh configuration
export ZSH=$DOTFILES/oh-my-zsh

ZSH_THEME="agnoster"

DISABLE_AUTO_UPDATE="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

ZSH_CUSTOM=$DOTFILES/omz-custom
plugins=(git)
source $ZSH/oh-my-zsh.sh
