# Concatenate all the files in the config dirs to generate a ~/.ssh/config
# file. They're processed in alphabetical order by base file name.

TARGET_SSH_CONFIG = ${HOME}/.ssh/config

all: ${TARGET_SSH_CONFIG}

CONFIG_DIR = ${DOTFILES}/ssh/config.d
LOCAL_CONFIG_DIR = ${HOME}/dotfiles.local/ssh/config.d

CONFIG_DIRS = ${CONFIG_DIR} ${LOCAL_CONFIG_DIR}

ALL_CONFIG_FILES = $(wildcard $(addsuffix /*, ${CONFIG_DIRS}))
SORTED_BASENAMES = $(sort $(notdir ${ALL_CONFIG_FILES}))
SORTED_ALL_POSSIBLE_CONFIGS = $(foreach name, ${SORTED_BASENAMES}, ${CONFIG_DIR}/${name} ${LOCAL_CONFIG_DIR}/${name})
SORTED_CONFIG_FILES = $(filter ${ALL_CONFIG_FILES}, ${SORTED_ALL_POSSIBLE_CONFIGS})

print-%: ; @echo $* = $($*)

${TARGET_SSH_CONFIG}: ${CONFIG_DIRS} ${SORTED_CONFIG_FILES}
	-mv $@ $@.$(shell date '+%Y-%m-%d@%T')~
	echo '# Automatically generated by $(abspath $(lastword ${MAKEFILE_LIST}))' > $@
	cat $(foreach name, $^,$(if $(shell test -d "${name}" || echo yes),${name})) >> $@

clean:
	-rm -rf ${TARGET_SSH_CONFIG}
