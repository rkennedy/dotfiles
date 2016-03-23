if ls --color=auto >&/dev/null; then
    alias ls='ls -obF --color'
else
    alias ls='ls -obF'
fi
alias la='ls -a'
alias rm='rm -i' cp='cp -i' mv='mv -i'

alias ps='ps -o "pid tty user time args"'
alias grep='grep --color=auto'

type dircolors >&/dev/null && {
    eval `dircolors -b $DOTFILES/dir_colors`
}

# Allow quick switching to bash
if whence -p bash >&/dev/null; then
    alias b='export SHELL=`whence -p bash`; exec $SHELL -l'
else
    alias b='echo no bash available'
fi

HISTSIZE=100
setopt hist_ignore_all_dups
# Include start time and elapsed time in history
setopt extended_history
# Add "|" to redirection instructions in history to allow clobbering
setopt hist_allow_clobber
# Don't display duplicates in history search
setopt hist_find_no_dups
# Don't add an item to history if it starts with space
setopt hist_ignore_space
# Don't keep function definitions in the history
setopt hist_no_functions
# Don't keep the `history` command in the history
setopt hist_no_store
# Normalize spaces in the history list
setopt hist_reduce_blanks

fignore=(.o ~ .rpo .class)
unset MAILCHECK IGNOREEOF CDPATH HISTFILE

# current directory in green. On next line, hostname and history number
PS1=$'[%F{green}%~%f]\n%m [%!]%(!.#.$) '

# Delay job-completion notification until printing of next prompt
unsetopt notify
# Don't exit the shell if there are background jobs running
setopt check_jobs

# Do not include usernames in the cd completion list
unsetopt cdable_vars

unsetopt auto_cd

# Use Emacs key bindings
bindkey -e

# Ctrl+Shift+Left&Right for navigating words
bindkey '^[[1;6C' forward-word
bindkey '^[[1;6D' backward-word

autoload -U compinit
compinit
# Do not autoselect the first completion entry
unsetopt menu_complete
# Add shashes to the ends of completed directory names, but remove them again if
# they're at the end of a word.
setopt auto_param_slash auto_remove_slash
# Attempt completion from the middle of a word, if that's where the cursor is.
setopt complete_in_word
# Show file-type marks in completion list
setopt list_types
bindkey '^r' history-incremental-search-backward


fpath=($DOTFILES/zsh $fpath)
autoload cvs_up cvs_diff
autoload pretty
autoload dark light
autoload no_powerline_fonts
autoload t

dark

ZSH_HIGHLIGHT_HIGHLIGHTERS=()
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main)
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets)
. $DOTFILES/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -r $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

[[ -r $POWERLINE_HOME/bindings/zsh/powerline.zsh ]] && . $POWERLINE_HOME/bindings/zsh/powerline.zsh
