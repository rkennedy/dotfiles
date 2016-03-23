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
	source $DOTFILES/base16-shell/base16-bright.dark.sh
}

light() {
	export COLORFGBG='1;15'
	source $DOTFILES/base16-shell/base16-bright.light.sh
}

no_powerline_fonts() {
	export NO_POWERLINE_FONTS=1
}

t() {
	: ${1:=default}
	exec tmux new-session -A "$@"
}
