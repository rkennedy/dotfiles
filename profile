if [ -n "$BASH_SOURCE" ]; then
    # sh is bash.
    self=${BASH_SOURCE[0]}
else
    >&2 printf "sh isn't bash\n"
    self=${HOME}/.profile
fi
real_self=`perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${self}"`
: ${DOTFILES:=`dirname "${real_self}"`}
: ${DOTFILES_LOCAL:=${HOME}/dotfiles.local}
export DOTFILES DOTFILES_LOCAL
unset self real_self

PATH=`${DOTFILES}/bin/generate-path "${PATH}" "${DOTFILES}/PATHrc"`
export PATH
MANPATH=`${DOTFILES}/bin/generate-path "${MANPATH}" "${DOTFILES}/MANPATHrc"`
export MANPATH

s() {
    if shell=`command -v zsh`; then
        :
    elif shell=`command -v bash`; then
        :
    else
        >&2 printf 'no better shell available\n'
        return 1
    fi
    SHELL=${shell}
    export SHELL
    exec ${SHELL} -l
}

# vim: set ft=sh et:
