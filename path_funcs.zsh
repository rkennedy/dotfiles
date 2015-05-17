declare_path_array() {
# Tie the given variable to an array (lowercase version).
# Make the array strip duplicates.
    typeset -T ${1} ${(L)1}
    typeset -U ${(L)1}
}

rk_path_import() {
    env=$1
    echo $env=("${(@f)$(source $file | sort -n | cut '-d ' -s -f 2-)}")
}
