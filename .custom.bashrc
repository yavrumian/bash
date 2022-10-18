# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# username@HOSTNAME [~](branch)  $> 
export PS1="\[\033[38;5;10m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;87m\]\h\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\]] \[$(tput sgr0)\]\[\033[38;5;1m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\]> \[$(tput sgr0)\]"

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
