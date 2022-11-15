function timer_now {
    date +%s%N
}

function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
}

# X (exec time) username@HOSTNAME [~](branch)  $> 
set_prompt () {
    Last_Command=$? # Must come first!
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'


    # If it was successful, print a green check mark. Otherwise, print a red X.
    PS=""
    if [[ $Last_Command == 0 ]]; then
        PS+="$Green$Checkmark "
    else
        PS+="$Red$FancyX "
    fi

    # Add the ellapsed time and current date
    timer_stop
    PS+="($timer_show) "

    # Print the working directory and prompt marker in blue, and reset
 PS1="$PS\[\033[38;5;87m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;10m\]\h\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\]] \[$(tput sgr0)\]\[\033[38;5;1m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\]> \[$(tput sgr0)\]"
 
    # the text color to the default.
}

trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'

###################### END OF BASH PROMPT CONFIG ###########################

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#terraform and aws completions
complete -C '/usr/local/bin/aws_completer' aws
complete -C /usr/bin/terraform terraform

export HISTCONTROL=ignoredups
export HISTIGNORE='clear:clr'
export BROWSER=wslview


alias clr='clear'
alias tf='terraform'
alias tfp='tf plan'
alias tfa='tf apply'
alias tfaa='tfa -auto-approve'
alias tfwl='tf workspace list'


awsprof() {
    export AWS_PROFILE=$1
}

tfws() {
    tf workspace select $1
}

chb() {
    git checkout $1
}

comm() {
	git commit -am "${1}"
}
inst(){
	sudo apt install -y $1
}
figlet -s Yavrumian | lolcat; echo -e "May the Force be With You and Father of Understanding Guide Us! \n" | lolcat
export PATH=$PATH:"/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft VS Code/bin/"
