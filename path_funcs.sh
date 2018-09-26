rk_path_remove () {
	local IFS=':'
	local NEWPATH
	local DIR
	local PATHVARIABLE=${2:-PATH}
	for DIR in ${!PATHVARIABLE} ; do
		[[ $DIR = $1 ]] || NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
	done
	export $PATHVARIABLE="$NEWPATH"
}

rk_path_prepend () {
	rk_path_remove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}
