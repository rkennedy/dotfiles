setopt prompt_subst

# Prompt functions should set $reply array to contain the prompt contents and
# the background color. It should set it to empty if there should be no
# contents for the prompt section.
#
# For color reference: https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit

function trace_depth()
{
    reply=()
    # Light gray on gray
    local fgc=250 bgc=240
    reply+=("%{%F{$fgc}%}%e")
    reply+=($bgc)
}

function trace_function()
{
    reply=()
    # Blue on white
    local fgc=4 bgc=7
    reply+=("%{%F{$fgc}%}%N:%i")
    reply+=($bgc)
}

function get_hostname_colors()
{
    local hosthash=$(hostname | cksum | awk '{print $1}')
    case $((hosthash % 7)) in
        0)
            # Dark gray on magenta
            fgc=233
            bgc=201
            ;;
        1)
            # Yellow on orange
            fgc=220
            bgc=166
            ;;
        2)
            # Light gray on red
            fgc=253
            bgc=160
            ;;
        3)
            # Dark gray on green
            fgc=233
            bgc=34
            ;;
        4)
            # Light gray on violet
            fgc=253
            bgc=99
            ;;
        5)
            # Black on seafoam
            fgc=232
            bgc=48
            ;;
        6)
            # Black on light orange
            fgc=232
            bgc=214
            ;;
    esac
}

function prompt_hostname()
{
    reply=()
    get_hostname_colors
    reply+=("%{%F{$fgc}%}%m")
    reply+=($bgc)
}

function prompt_user()
{
    reply=()
    # White on cyan
    local fgc=231 bgc=31
    reply+=("%{%F{$fgc}%}%B%n")
    reply+=($bgc)
}

function prompt_cwd()
{
    reply=()
    # Gray on dark gray
    local fgc=250 bgc=240
    local ellipsis='⋯'
    # If the path length is four or more components, start with an ellipsis.
    # Then give the final three path components.
    local cwd=${(%):-%4(~:$ellipsis/:)%3~}
    local -a result
    if [[ $cwd == '/' ]]; then
        result+=('/')
    else
        if [[ $cwd =~ '^/' ]]; then
            # path is absolute
            result+=('/')
            cwd="${cwd[2,-1]}"
        fi
        # Split the remaining path string on slashes.
        # Escape percent signs so when the prompt evaluates the result, the
        # names are interpretted correctly.
        result+=(${(@s:/:)cwd:s/\%/\%\%})
    fi
    # The last path component should appear bold
    result[-1]=("%B${result[-1]}")
    # Quote all the components so that when we use the "e" modifier below,
    # only the separator variable gets expanded and not the path components,
    # which can happen if a $ appears in a directory name.
    result=(${(q@)result})
    if [[ ${result[1]} == '/' ]]; then
        result[1]=""
    fi
    reply+=("%{%F{$fgc}%}${(ej:/:)result}")
    reply+=($bgc)
}

function capture_jobcount()
{
    jobcount=${(%):-%j}
}
precmd_functions+=(capture_jobcount)

function prompt_jobs()
{
    reply=()
    if ((${jobcount} > 0)); then
        # Yellow on orange
        local fgc=220 bgc=166
        reply+=("%{%F{$fgc}%}%j")
        reply+=($bgc)
    fi
}

function prompt_kubecontext()
{
    reply=()
    local context
    context=$(kubectl config current-context 2>/dev/null)
    if (($? == 0)); then
        # white on blue
        local fgc=15 bgc=27
        reply+=("%{%F{$fgc}%}✵$context")
        reply+=($bgc)
    fi
}

function prompt_aws()
{
    reply=()
    if ((${+AWS_PROFILE} == 1)); then
        # block on orange
        local fgc=0 bgc=172
        reply+=("%{%F{$fgc}%}☁ ${AWS_PROFILE}")
        reply+=($bgc)
    fi
}

function prompt_pipestatus()
{
    local -a ps
    ps=($pipestat)
    reply=()
    local success
    success=(0)
    local result
    if ((${#ps:*success} != ${#ps})); then
        local -a values
        local fgc
        local fgc2=231  # white
        local bgc=240  # gray
        for s in $ps; do
            if (($s == 0)); then
                fgc=46  # green
            else
                fgc=196  # red
            fi
            values+=("%{%F{$fgc}%K{$bgc}%}%B$s%b%{%F{$fgc2}%K{$bgc}%}")
        done
        reply+=(${(ej: | :)values})
        reply+=($bgc)
    fi
}

function prompt_git_commit()
{
    reply=()
    local ID
    ID=$(git symbolic-ref --quiet --short HEAD || git describe --all --exact-match || git rev-parse --short HEAD) 2> /dev/null
    if (($? == 0)); then
        # Gray on dark gray
        local fgc=250 bgc=236
        reply+=("%{%F{$fgc}%}ᚠ ${ID:s/\%/\%\%}")
        reply+=($bgc)
    fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
function prompt_virtual_env()
{
    reply=()
    if ((${+VIRTUAL_ENV} == 1)); then
        # Dark blue on white
        local fgc=33 bgc=253
        reply+=("%{%F{$fgc}%}${VIRTUAL_ENV:t}")
        reply+=($bgc)
    fi
}

typeset -a ps1_functions
typeset -a rps1_functions
typeset -a ps4_functions

ps1_functions=(
    prompt_hostname
    prompt_user
    prompt_cwd
    prompt_jobs
)
rps1_functions=(
    prompt_pipestatus
    prompt_git_commit
    prompt_virtual_env
    prompt_kubecontext
    prompt_aws
)
ps4_functions=(
    trace_depth
    trace_function
)

function do_prompt()
{
    local result
    local function_list="${1}_functions"
    for func in ${(@P)function_list}; do
        $func
        if ((${#reply} > 0)); then
            text=${reply[1]}
            start_bgc=${reply[2]}
            result+="%{%K{${start_bgc}}%} ${text} %{%k%f%b%}"
        fi
    done
    result+="%{%k%f%}"
    if [ "${1}" != rps1 ]; then
        result+=' '
    fi
    print -n $result
}

PS1='$(do_prompt ps1)'
RPS1='$(pipestat=($pipestatus) do_prompt rps1)'
PS4="$(do_prompt ps4)"

# vim: set ts=4 et sw=4:
