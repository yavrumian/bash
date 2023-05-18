function timer_now {
    date +%s%N
}
function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

__kube_ps1()
{
		CYA='\033[0;36m'
		RED='\033[0;31m'
		LCYA='\033[1;36m'
		NC='\033[0m'
		# Get current context
		CONTEXT=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //")
	    if [ -n "$CONTEXT" ] && [ "$CONTEXT" != "\"\"" ]; then
			NS=$(kubectl config view --minify -o jsonpath='{..namespace}')
	        echo -e "(${CYA}${CONTEXT}:${LCYA} ${NS}${NC})"
		fi
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
 PS1="$PS\[\033[38;5;87m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\]] \$(__kube_ps1) \[$(tput sgr0)\]\[\033[38;5;1m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\]> \[$(tput sgr0)\]"
 
    # the text color to the default.
}

trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'

###################### END OF BASH PROMPT CONFIG ###########################

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#terraform and aws completions
complete C '/usr/local/bin/aws_completer' aws
complete -C /usr/bin/terraform terraform
source <(kubectl completion bash)

export HISTCONTROL=ignoredups
export HISTIGNORE='clear:clr'
export BROWSER=wslview


alias clr='clear'
alias tf='terraform'
alias tfp='tf plan'
alias tfa='tf apply'
alias tfaa='tfa -auto-approve'
alias tfwl='tf workspace list'
alias k=kubectl
alias kc='export KUBE_EDITOR="code -w"; echo "Kube Editor set to VSCode"'
alias kv='export KUBE_EDITOR="Vim"; echo "Kube Editor set to Vim"'
alias kd='kubectl describe'
complete -o default -F __start_kubectl kd
complete -o default -F __start_kubectl k

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
42c(){
	gcc -Wall -Wextra -Werror $@
}

norm(){
	norminette -R CheckForbiddenSourceHeader $@
}
figlet -s Yavrumian | lolcat; echo -e "May the Force be With You and Father of Understanding Guide Us! \n" | lolcat
export PATH=$PATH:"/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft VS Code/bin/"
bind "set completion-ignore-case on"

# sudo service docker start > /dev/null
export PATH=/home/yavrumian/.local/bin:/home/yavrumian/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft\ VS\ Code/bin:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft\ VS\ Code/bin/:/home/yavrumian/.local/bin1~:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft\ VS\ Code/bin/:/home/yavrumian/.linkerd2/bin
