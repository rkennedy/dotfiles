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
zmodload zsh/zutil
setopt prompt_subst

autoload colors && colors

zstyle :prompts:rkline security-indicator ''

# Prompt function should set $reply array to contain the prompt contents,
# the starting background color, and the ending background color. It should
# set it to empty if there should be no contents for the prompt section.
zstyle ':prompts:*:prompt_hostname' fg '220'
zstyle ':prompts:*:prompt_hostname' bg '166'
function prompt_hostname()
{
    reply=()
    if (($+SSH_CLIENT)); then
        zstyle -g secure_char :prompts:rkline security-indicator
        zstyle -g fgc ':prompts:*:prompt_hostname' fg
        zstyle -g bgc ':prompts:*:prompt_hostname' bg
        reply+=("%{%F{$fgc}%K{$bgc}%}${secure_char} %m")
        reply+=($bgc $bgc)
    fi
}
zstyle ':prompts:*:prompt_user' fg 'white'  # also bold
zstyle ':prompts:*:prompt_user' bg '31'
function prompt_user()
{
    reply=()
    zstyle -g fgc ':prompts:*:prompt_user' fg
    zstyle -g bgc ':prompts:*:prompt_user' bg
    reply+=("%{%F{$fgc}%K{$bgc}%}%n")
    reply+=($bgc $bgc)
}
zstyle ':prompts:*:prompt_cwd' fg '250'  # last component also bold
zstyle ':prompts:*:prompt_cwd' bg '240'
zstyle ':prompts:rkline:prompt_cwd' ps '  '
zstyle ':prompts:rkline' ellipsis '⋯'
function prompt_cwd()
{
    reply=()
    zstyle -g fgc ':prompts:*:prompt_cwd' fg
    zstyle -g bgc ':prompts:*:prompt_cwd' bg
    zstyle -s ':prompts:rkline' ellipsis ellipsis
    # If the path length is four or more components, start with an ellipsis.
    # Then give the final three path components.
    cwd=${(%):-%4(~:$ellipsis/:)%3~}
    #cwd=${(%):-%3~}
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
    zstyle -s ':prompts:rkline:prompt_cwd' ps ps
    reply+=("%{%F{$fgc}%K{$bgc}%}${(ej:${ps}:)result}")
    reply+=($bgc $bgc)
}
zstyle ':prompts:*:prompt_jobs' fg '220'
zstyle ':prompts:*:prompt_jobs' bg '166'
function prompt_jobs()
{
    reply=()
    if ((${(%):-%j} > 0)); then
        zstyle -g fgc ':prompts:*:prompt_jobs' fg
        zstyle -g bgc ':prompts:*:prompt_jobs' bg
        reply+=("%{%F{$fgc}%K{$bgc}%}%j")
        reply+=($bgc $bgc)
    fi
}
zstyle ':prompts:*:prompt_pipestatus:pass' fg 'white'
zstyle ':prompts:*:prompt_pipestatus:fail' fg 'white'
zstyle ':prompts:*:prompt_pipestatus:pass' bg 'green'
zstyle ':prompts:*:prompt_pipestatus:fail' bg 'dark red'
zstyle ':prompts:*:prompt_pipestatus' separator '|'
function prompt_pipestatus()
{
    local -a ps
    ps=($pipestatus)
    reply=()
    local success=(0)
    local result
    if [[ ${#ps:*success} -ne ${#ps} ]]; then
        zstyle -g sep ':prompts:*:prompt_pipestatus' separator
        local first=0
        for s in $ps; do
            if [[ $s -eq 0 ]]; then
                zstyle -g fgc 'prompts:*:prompt_pipestatus:pass' fg
                zstyle -g bgc 'prompts:*:prompt_pipestatus:pass' bg
            else
                zstyle -g fgc 'prompts:*:prompt_pipestatus:fail' fg
                zstyle -g bgc 'prompts:*:prompt_pipestatus:fail' bg
            fi
            if [[ $first -ne 0 ]]; then
                first=1
                result+=" %{%F{$bgc}%}$sep%{%F{$fgc}%K{$bgc}%} $s"
            else
                result+="%{%F{$fgc}%K{$bgc}%}${s}"
                first_bgc=$bgc
            fi
        done
        reply+=($result)
        reply+=($first_bgc $bgc)
    fi
    print $reply
}
zstyle ':prompts:*:prompt_git_commit' fg 250
zstyle ':prompts:*:prompt_git_commit' bg 236
zstyle ':prompts:rkline' branch ''
function prompt_git_commit()
{
    reply=()
    ID=$(git symbolic-ref --quiet --short HEAD || git describe --all --exact-match || git rev-parse --short HEAD) 2> /dev/null
    if (($? == 0)); then
        zstyle -g fgc ':prompts:*:prompt_git_commit' fg
        zstyle -g bgc ':prompts:*:prompt_git_commit' bg
        zstyle -g BRANCH ':prompts:rkline' branch
        reply+=("%{%F{$fgc}%K{$bgc}%}${BRANCH} ${ID}")
        reply+=($bgc $bgc)
    fi
}

typeset -a ps1_functions
typeset -a rps1_functions

ps1_functions+=(prompt_hostname)
ps1_functions+=(prompt_user)
ps1_functions+=(prompt_cwd)
#ps1_functions+=(prompt_jobs)
#rps1_functions+=(prompt_pipestatus)
rps1_functions+=(prompt_git_commit)

function do_left_prompt()
{
    local prompt_pipestatus=$pipestatus
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
    local prompt_pipestatus=$pipestatus
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
RPS1='$(do_right_prompt)'
