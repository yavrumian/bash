#!/bin/bash

# Function to get the current timestamp in seconds and nanoseconds
timer_now() {
    date +%s%N
}

# Function to start the timer
timer_start() {
    timer_start=${timer_start:-$(timer_now)}
}

# Function to display the current Kubernetes context and namespace in the prompt
__kube_ps1() {
    CYA='\033[0;36m'
    RED='\033[0;31m'
    LCYA='\033[1;36m'
    NC='\033[0m'
    
    # Get current context
    CONTEXT=$(grep -oP '(?<=current-context: ).*' ~/.kube/config)
    
    if [ -n "$CONTEXT" ] && [ "$CONTEXT" != "\"\"" ]; then
        NS=$(kubectl config view --minify -o jsonpath='{..namespace}')
        echo -e "(${CYA}${CONTEXT}:${LCYA} ${NS}${NC})"
    fi
}

# Function to stop the timer and calculate the elapsed time
timer_stop() {
    if [[ -z "$timer_start" ]]; then
        return
    fi
    
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then
        timer_show=${h}h${m}m
    elif ((m > 0)); then
        timer_show=${m}m${s}s
    elif ((s >= 10)); then
        timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then
        timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then
        timer_show=${ms}ms
    elif ((ms > 0)); then
        timer_show=${ms}.$((us / 100))ms
    else
        timer_show=${us}us
    fi
    
    unset timer_start
}

# Function to set the custom prompt
set_prompt() {
    Last_Command=$? # Must come first!
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    # If the last command was successful, print a green check mark. Otherwise, print a red X.
    PS=""
    if [[ $Last_Command == 0 ]]; then
        PS+="$Green$Checkmark "
    else
        PS+="$Red$FancyX "
    fi

    # Add the elapsed time and current date
    timer_stop
    PS+="($timer_show) "
    
    # Print the working directory, Kubernetes context and namespace, and Git branch in the prompt
    PS1="$PS\[\033[38;5;87m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\]] \$(__kube_ps1) \[$(tput sgr0)\]\[\033[38;5;1m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\]> \[$(tput sgr0)\]"
}

# Start the timer when a command is executed
trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'

###################### END OF BASH PROMPT CONFIG ###########################

# Configure command history settings
HISTSIZE=1000
HISTFILESIZE=2000

# Terraform and AWS completions
complete C '/usr/local/bin/aws_completer' aws
complete -C /usr/bin/terraform terraform
source <(kubectl completion bash)

# Set history control and ignore patterns
export HISTCONTROL=ignoredups
export HISTIGNORE='clear:clr'

# Set the default web browser
export BROWSER=wslview

# Define aliases
alias la='ls -la'
alias clr='clear'
alias tf='terraform'
alias tfp='tf plan'
alias tfa='tf apply'
alias tfaa='tfa -auto-approve'
alias tfwl='tf workspace list'
alias k=kubectl
alias kc='export KUBE_EDITOR="code -w"; echo "Kube Editor set to VSCode"'
alias kv='export KUBE_EDITOR="vim"; echo "Kube Editor set to Vim"'
alias kd='kubectl describe'
alias kls='k get po'

# Enable autocompletion for kubectl commands
complete -o default -F __start_kubectl kd
complete -o default -F __start_kubectl k

# Set AWS profile
awsprof() {
    export AWS_PROFILE=$1
}

# Select Terraform workspace
tfws() {
    tf workspace select $1
}

# Git checkout branch
chb() {
    git checkout $1
}

# Git commit with message
comm() {
    git commit -am "${1}"
}

# Install packages using apt
inst(){
    sudo apt install -y $1
}

# Compile C files with specific flags
42c(){
    gcc -Wall -Wextra -Werror $@
}

# Execute command with kubectl exec in a pod
kx(){
    k exec $1 -it -- $2 
}

bck(){
    cp $1 $1.bck
    echo "$1.bck created"
}

# Run norminette on files
norm(){
    norminette -R CheckForbiddenSourceHeader $@
}

# Display a customized welcome message
figlet -s Yavrumian | lolcat
echo -e "May the Force be With You and Father of Understanding Guide Us! \n" | lolcat

# Add VS Code binary path to the PATH environment variable
export PATH=$PATH:"/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft VS Code/bin/"

# Set case-insensitive completion
bind "set completion-ignore-case on"

# Set additional paths in the PATH environment variable
export PATH=/home/yavrumian/.local/bin:/home/yavrumian/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft\ VS\ Code/bin:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft\ VS\ Code/bin/:/home/yavrumian/.local/bin1~:/mnt/c/Users/vahe.yavrumyan/AppData/Local/Programs/Microsoft\ VS\ Code/bin/:/home/yavrumian/.linkerd2/bin
