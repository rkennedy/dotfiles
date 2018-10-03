setopt prompt_subst

# Prompt functions should set $reply array to contain the prompt contents and
# the background color. It should set it to empty if there should be no
# contents for the prompt section.

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
    local hosthash=$(hostname | cksum | cut -f1 -d' ')
    case $((hosthash % 4)) in
        0)
            fgc=233
            bgc=201
            ;;
        1)
            # Yellow on orange
            fgc=220
            bgc=166
            ;;
        2)
            fgc=21
            bgc=196
            ;;
        3)
            fgc=21
            bgc=34
            ;;
    esac
}

function prompt_hostname()
{
    reply=()
    if (($+SSH_CLIENT)); then
        get_hostname_colors
        reply+=("%{%F{$fgc}%}%m")
        reply+=($bgc)
    fi
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
ps1_functions=()
typeset -a rps1_functions
rps1_functions=()
typeset -a ps4_functions
ps4_functions=()

ps1_functions+=(prompt_hostname)
ps1_functions+=(prompt_user)
ps1_functions+=(prompt_cwd)
ps1_functions+=(prompt_jobs)
rps1_functions+=(prompt_pipestatus)
rps1_functions+=(prompt_git_commit)
rps1_functions+=(prompt_virtual_env)
ps4_functions+=(trace_depth)
ps4_functions+=(trace_function)

function do_left_prompt()
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
    result+="%{%k%f%} "
    print -n $result
}

function do_right_prompt()
{
    local result
    for func in ${(@)rps1_functions}; do
        $func
        if ((${#reply} > 0)); then
            text=${reply[1]}
            start_bgc=${reply[2]}
            result+="%{%K{$start_bgc}%} ${text} %{%k%f%b%}"
        fi
    done
    result+="%{%k%}"
    print -n $result
}

PS1='$(do_left_prompt ps1)'
RPS1='$(pipestat=($pipestatus) do_right_prompt)'
PS4="$(do_left_prompt ps4)"

# vim: set ts=4 et sw=4:
