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
