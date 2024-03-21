.PHONY: bootstrap submodules

LN = ln
ifeq (${OS},Windows_NT)
    vim_undo_file = ${APPDATA}/Vim/undo
    nvim_undo_file = ${APPDATA}/Nvim/undo
else
    XDG_CONFIG_HOME ?= ${HOME}/.config
    XDG_DATA_HOME ?= ${HOME}/.local/share
    XDG_STATE_HOME ?= ${HOME}/.local/state

    ifeq ($(shell uname -s),Darwin)
	LN = gln  # We want the GNU version for --no-target-directory.
        vim_undo_file = ${HOME}/Library/Vim/undo
        nvim_undo_file = ${HOME}/Library/nvim/undo
    else
        vim_undo_file = ${XDG_DATA_HOME}/vim/undo
        nvim_undo_file = ${XDG_STATE_HOME}/nvim/undo
    endif

endif

# These are files that should be linked in the home directory. Compare with
# config_link_files, below.
home_files_to_be_linked =
home_files_to_be_linked += ackrc
home_files_to_be_linked += bash_profile
home_files_to_be_linked += bashrc
home_files_to_be_linked += colordiffrc
home_files_to_be_linked += hammerspoon
home_files_to_be_linked += gitconfig
home_files_to_be_linked += inputrc
home_files_to_be_linked += tmux.conf
home_files_to_be_linked += vimrc
home_files_to_be_linked += zshenv
home_files_to_be_linked += zshrc

home_link_files = $(addprefix ${HOME}/., ${home_files_to_be_linked})

# These are files that should be linked in $XDG_CONFIG_HOME. Compare with
# home_link_files, above.
config_files_to_be_linked =
config_files_to_be_linked += atuin
config_files_to_be_linked += nvim

config_link_files = $(addprefix ${XDG_CONFIG_HOME}/, ${config_files_to_be_linked})

# These are files that should be linked to $XDG_DATA_HOME. They'll have a
# "-data" suffix to avoid overlap with similarly named files in
# XDG_CONFIG_HOME.
data_files_to_be_linked =
data_files_to_be_linked += nvim  # Named nvim-data in the repo.

data_link_files = $(addprefix ${XDG_DATA_HOME}/, ${data_files_to_be_linked})

bootstrap: submodules ${home_link_files} ${config_link_files} ${data_link_files} ${vim_undo_file} ${nvim_undo_file}

submodules:
	git submodule update --init --recursive

${HOME}/.%: %
	${LN} --symbolic --no-target-directory $(realpath $<) $@

${XDG_CONFIG_HOME}/%: %
	mkdir -p $(dir $@)
	${LN} --symbolic --no-target-directory $(realpath $<) $@

${XDG_DATA_HOME}/%: %-data
	mkdir -p $(dir $@)
	${LN} --symbolic --no-target-directory $(realpath $<) $@

${vim_undo_file}:
	mkdir -p $@

${nvim_undo_file}:
	mkdir -p $@

# Disable implicit rules. Makes debug output easier to read.
%: %,v

%: RCS/%,v

%: RCS/%

%: s.%

%: SCCS/s.%

.SUFFIXES:

print-%: ; @echo $* = $($*)
