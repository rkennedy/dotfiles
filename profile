if [ -n "$BASH_SOURCE" ]; then
    # sh is bash.
    self=${BASH_SOURCE[0]}
else
    >&2 printf "sh isn't bash\n"
    self=${HOME}/.profile
fi
if [ -z "${DOTFILES:+x}" ]; then
    self=`perl -MCwd=realpath -e 'print realpath($ARGV[0])' "${self}"`
    DOTFILES=`dirname "${self}"`
    export DOTFILES
fi
unset self

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
