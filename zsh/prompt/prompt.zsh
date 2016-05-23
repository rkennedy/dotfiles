# Prompt:
# On left:
# - remote host name, plus SSH indicator: ${(%):-%m}, plus ?
# - current user name: ${(%):-%n}
# - abbreviated path: ${(%):-%3~}
# - number of background jobs: ${(%):-%j}
#
# On right:
# - results of previous command pipeline: ${pipestatus[@]}
# - current branch or commit ID, if in source repo
setopt prompt_subst

# Prompt functions should set $reply array to contain the prompt contents,
# the starting background color, and the ending background color. It should
# set it to empty if there should be no contents for the prompt section.

function trace_depth()
{
    reply=()
    # Light gray on gray
    local fgc=250 bgc=240
    reply+=("%{%F{$fgc}%K{$bgc}%}%e")
    reply+=($bgc $bgc)
}

function trace_function()
{
    reply=()
    ((${NO_POWERLINE_FONTS:-0} == 0))
    local sep=${(%):-%(?.'  '.:)}
    # Blue on white
    local fgc=4 bgc=7
    reply+=("%{%F{$fgc}%K{$bgc}%}%N${sep}%i")
    reply+=($bgc $bgc)
}

function prompt_hostname()
{
    reply=()
    if (($+SSH_CLIENT)); then
        ((${NO_POWERLINE_FONTS:-0} == 0))
        local secure_char=${(%):-%(?.' '.)}
        # Yellow on orange
        local fgc=220 bgc=166
        reply+=("%{%F{$fgc}%K{$bgc}%}${secure_char}%m")
        reply+=($bgc $bgc)
    fi
}

function prompt_user()
{
    reply=()
    # White on cyan
    local fgc=231 bgc=31
    reply+=("%{%F{$fgc}%K{$bgc}%}%B%n%b%{%K{$bgc}%}")
    reply+=($bgc $bgc)
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
    result[-1]=("%B${result[-1]}%b")
    # Quote all the components so that when we use the "e" modifier below,
    # only the separator variable gets expanded and not the path components,
    # which can happen if a $ appears in a directory name.
    result=(${(q@)result})
    ((${NO_POWERLINE_FONTS:-0} == 0))
    local ps=${(%):-%(?.'  './)}
    reply+=("%{%F{$fgc}%K{$bgc}%}${(ej:${ps}:)result}%{%K{$bgc}%}")
    reply+=($bgc $bgc)
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
        reply+=("%{%F{$fgc}%K{$bgc}%}%j")
        reply+=($bgc $bgc)
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
        local first=1
        local previous_s
        local fgc bgc first_bgc
        for s in $ps; do
            if (($s == 0)); then
                # White on dark green
                fgc=231
                bgc=22
            else
                # White on dark red
                fgc=231
                bgc=52
            fi
            if (($first == 1)); then
                result+="%{%F{$fgc}%K{$bgc}%}"
                first_bgc=$bgc
                first=0
            else
                if (($s == 0 ^^ $previous_s == 0)); then
                    ((${NO_POWERLINE_FONTS:-0} == 0))
                    result+=" %{%F{$bgc}%}${(%):-%(?..)}%{%F{$fgc}%K{$bgc}%} "
                else
                    ((${NO_POWERLINE_FONTS:-0} == 0))
                    result+=" ${(%):-%(?..|)} "
                fi
            fi
            result+="${s}"
            previous_s=$s
        done
        reply+=($result)
        reply+=($first_bgc $bgc)
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
        ((${NO_POWERLINE_FONTS:-0} == 0))
        local branch=${(%):-%(?.''.±)}
        reply+=("%{%F{$fgc}%K{$bgc}%}${branch:s/\%/\%\%} ${ID:s/\%/\%\%}")
        reply+=($bgc $bgc)
    fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
function prompt_virtual_env()
{
    reply=()
    if ((${+VIRTUAL_ENV} == 1)); then
        # Dark blue on white
        local fgc=33 bgc=253
        reply+=("%{%F{$fgc}%K{$bgc}%}${VIRTUAL_ENV:t}")
        reply+=($bgc $bgc)
    fi
}

typeset -a ps1_functions
typeset -a rps1_functions
typeset -a ps4_functions

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
    ((${NO_POWERLINE_FONTS:-0} == 0))
    local sep=${(%):-%(?.''.)}
    local first=1
    local result
    local function_list="${1}_functions"
    for func in ${(@P)function_list}; do
        $func
        if ((${#reply} > 0)); then
            text=${reply[1]}
            start_bgc=${reply[2]}
            end_bgc=${reply[3]}
            result+="%{%K{$start_bgc}%}"
            if [ $first -eq 0 ]; then
                result+="${sep}"
            else
                first=0
            fi
            result+="%{%K{${start_bgc}}%} ${text} "
            result+="%{%F{${end_bgc}}%}"
        fi
    done
    result+="%{%k%}$sep%{%f%} "
    print -n $result
}

function do_right_prompt()
{
    ((${NO_POWERLINE_FONTS:-0} == 0))
    local sep=${(%):-%(?.''.)}
    local result
    for func in ${(@)rps1_functions}; do
        $func
        if ((${#reply} > 0)); then
            text=${reply[1]}
            start_bgc=${reply[2]}
            end_bgc=${reply[3]}
            result+="%{%F{$start_bgc}%}$sep%{%f%}"
            result+="%{%K{$start_bgc}%} ${text} "
        fi
    done
    result+="%{%k%}"
    print -n $result
}

PS1='$(do_left_prompt ps1)'
RPS1='$(pipestat=($pipestatus) do_right_prompt)'
PS4="$(do_left_prompt ps4)"
