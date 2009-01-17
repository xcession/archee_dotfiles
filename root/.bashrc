#
# ~/.bashrc
#

alias mv="mv -v --backup=existing"
alias rm="rm -v"
alias cp="cp -v"
alias grep="grep --color=auto"

alias ls="ls -hF -a --color=auto"

alias shutdown="shutdown -hP -t 0 now"
alias clean="pacman -Qdt && pacman -Scc && updatedb"
alias df="df -h"

# bash prompt styles
PS1="\[\033[31m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]# "

eval `dircolors -b ~/.dircolors`

# command history settings
export PATH="/opt/java/bin:$PATH"

# bash completion
complete -cf sudo         # sudo tab-completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
