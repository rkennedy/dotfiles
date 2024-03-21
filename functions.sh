..() {
	cd ..
}

rehash() {
	hash -r
}

t() {
	: ${1:=default}
	exec tmux new-session -A "$@"
}
