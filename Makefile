.PHONY: bootstrap submodules

ifeq (${OS},Windows_NT)
    undo_file = ${APPDATA}/Vim/undo
else
    XDG_CONFIG_HOME := $(shell echo \${XDG_CONFIG_HOME:\$HOME/.config})
    ifeq ($(shell uname -s),Darwin)
        undo_file = ${HOME}/Library/Vim/undo
    else
        XDG_DATA_HOME := $(shell echo \${XDG_DATA_HOME:\$HOME/.local/share})
        undo_file = ${XDG_DATA_HOME}/vim/undo
    endif
endif


files_to_be_linked =
files_to_be_linked += ackrc
files_to_be_linked += bash_profile
files_to_be_linked += bashrc
files_to_be_linked += colordiffrc
files_to_be_linked += hammerspoon
files_to_be_linked += gitconfig
files_to_be_linked += inputrc
files_to_be_linked += tmux.conf
files_to_be_linked += vimrc
files_to_be_linked += zshenv
files_to_be_linked += zshrc

link_files = $(addprefix ${HOME}/., ${files_to_be_linked})

bootstrap: submodules ${link_files} ${XDG_CONFIG_HOME} ${undo_file}

submodules:
	git submodule update --init --recursive

${HOME}/.%: %
	ln -s $(realpath $^) $@

${XDG_CONFIG_HOME}:
	mkdir -p $@

${undo_file}:
	mkdir -p ${undo_file}

# Disable implicit rules. Makes debug output easier to read.
%: %,v

%: RCS/%,v

%: RCS/%

%: s.%

%: SCCS/s.%

.SUFFIXES:

print-%: ; @echo $* = $($*)
