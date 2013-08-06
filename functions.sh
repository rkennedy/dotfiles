evcd() {
    if [[ x$3 == x ]]; then
        evidence=/net/${1}spt/evidence/$1
    else
        evidence=/net/$3/evidence/$1
    fi
	titan='([[:digit:]]{3})-?([[:digit:]]{3})-?([[:digit:]]([[:digit:]]{2}))';
	etrack='([eE][tT])?([[:digit:]]{7})';
	sfdc='[[:digit:]]{8}'
	if [[ $2 =~ $sfdc ]]; then
		dir=$evidence/${2:6:8}/$2
		echo cd $dir
		cd $dir
	elif [[ $2 =~ $titan ]]; then
		dir=$evidence/${BASH_REMATCH[4]}/${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-${BASH_REMATCH[3]};
		echo cd $dir;
		cd $dir;
	elif [[ $2 =~ $etrack ]]; then
		echo $etrack;
		caseno=$(extrefs ${BASH_REMATCH[2]} | head -1);
		if [[ $? ]]; then
			evcd $1 $caseno $3
		fi
	fi
}
rosspt() { evcd ros $1 ross550/vol/exports; }
sprspt() { evcd spr $1 spr-evidence.spr.spt.symantec.com/c; }
sydspt() { evcd syd $1; }
rdgspt() { evcd rdg $1; }
hrospt() { evcd hro $1 hro-evidence.spr.spt.symantec.com/c; }
punspt() { evcd pun $1; }

nmakeall() {
	for plat in x86 AMD64 IA64; do
		nmake -t y -a $plat "$@"
	done
}
makeall() {
	/usr/bin/make TrustLibs=yes "$@"
	nmakeall
}
m() {
	case "${1:-all}" in
	'x86'|'AMD64'|'IA64')
		nmake -t y -a "$1" "${@:2}"
		;;
	'all')
		makeall "${@:2}"
		;;
	*)
		/usr/bin/make TrustLibs=yes P="$1" "${@:2}"
	esac
}
cvs_up() {
	find ${@:-.} -type d -name CVS -prune \
		| sed 's/\/CVS//' \
		| xargs cvs up -l \
		| grep -v -E '^\?'
}
cvs_diff() {
	cvs diff -uNp "$@" \
		| grep -v -E '^\?' \
		| colordiff \
		| less -RF
}

export GREP_OPTIONS=--color=auto

..() {
	cd ..
}

rehash() {
	hash -r
}

pretty() {
	pygmentize -g -f terminal256 -O bg=dark "$@" \
	| $PAGER -RF
}

dark() {
	export COLORFGBG='15;1'
}
