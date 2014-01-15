# This file is run for interactive login shells.

case $(hostname) in
	coachwood )
		umask 002
		;;
	*)
		umask 022
esac

# Source the file that's executed for interactive non-login shells.
[ -r $HOME/.bashrc ] && source $HOME/.bashrc
