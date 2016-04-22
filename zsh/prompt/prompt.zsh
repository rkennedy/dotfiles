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

autoload colors && colors

# Prompt functions should set $reply array to contain the prompt contents,
# the starting background color, and the ending background color. It should
# set it to empty if there should be no contents for the prompt section.

function prompt_hostname()
{
    reply=()
    if (($+SSH_CLIENT)); then
        local secure_char=''
        local fgc=220 bgc=166
        reply+=("%{%F{$fgc}%K{$bgc}%}${secure_char} %m")
        reply+=($bgc $bgc)
    fi
}

function prompt_user()
{
    reply=()
    local fgc=231 bgc=31
    reply+=("%{%F{$fgc}%K{$bgc}%}%B%n%b%{%K{$bgc}%}")
    reply+=($bgc $bgc)
}

function prompt_cwd()
{
    reply=()
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
        result+=("${(q@s:/:)cwd}")
    fi
    result[-1]=("%B${result[-1]}%b")
    local ps='  '
    reply+=("%{%F{$fgc}%K{$bgc}%}${(ej:${ps}:)result}%{%K{$bgc}%}")
    reply+=($bgc $bgc)
}

function prompt_jobs()
{
    reply=()
    if ((${(%):-%j} > 0)); then
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
    local success=(0)
    local result
    if ((${#ps:*success} != ${#ps})); then
        local first=1
        local previous_s
        local fgc bgc first_bgc
        for s in $ps; do
            if (($s == 0)); then
                fgc=231
                bgc=22
            else
                fgc=231
                bgc=52
            fi
            if (($first == 1)); then
                result+="%{%F{$fgc}%K{$bgc}%}"
                first_bgc=$bgc
                first=0
            else
                if (( ($s == 0 && $previous_s == 0) || ($s != 0 && $previous_s != 0) )); then
                    result+="  "
                else
                    result+=" %{%F{$bgc}%}%{%F{$fgc}%K{$bgc}%} "
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
        local fgc=250 bgc=236
        local branch=''
        reply+=("%{%F{$fgc}%K{$bgc}%}${branch} ${ID}")
        reply+=($bgc $bgc)
    fi
}

typeset -a ps1_functions
typeset -a rps1_functions

ps1_functions+=(prompt_hostname)
ps1_functions+=(prompt_user)
ps1_functions+=(prompt_cwd)
#ps1_functions+=(prompt_jobs)
rps1_functions+=(prompt_pipestatus)
rps1_functions+=(prompt_git_commit)

function do_left_prompt()
{
    local sep=''
    local first=1
    local result
    for func in ${(@)ps1_functions}; do
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
    local sep=''
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

PS1='$(do_left_prompt)'
RPS1='$(pipestat=($pipestatus) do_right_prompt)'
