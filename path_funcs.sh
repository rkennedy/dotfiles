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

rk_path_append () {
	rk_path_remove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

rk_path_import () {
	env=$1
	file=$2
	[[ -r $file ]] && while read item
	do
		rk_path_append $item $env
	done < <(source $file | sort -n | cut '-d ' -s -f 2-)
}
