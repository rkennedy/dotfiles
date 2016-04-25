..() {
	cd ..
}

rehash() {
	hash -r
}

dark() {
	export COLORFGBG='15;1'
	source $DOTFILES/base16-shell/base16-bright.dark.sh
}

light() {
	export COLORFGBG='1;15'
	source $DOTFILES/base16-shell/base16-bright.light.sh
}

update_color() {
	local -a colors
	colors=(${COLORFGBG//;/ })
	if ((${colors[0]} > ${colors[1]})); then
		local shade=dark
	else
		local shade=light
	fi
	source $DOTFILES/base16-shell/base16-bright.${shade}.sh
}

no_powerline_fonts() {
	export NO_POWERLINE_FONTS=1
}

t() {
	: ${1:=default}
	exec tmux new-session -A "$@"
}
