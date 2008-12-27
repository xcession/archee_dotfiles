#
# ~/.bashrc
#

alias mv="mv -v --backup=existing"
alias rm="rm -v"
alias cp="cp -v"
alias mplayer="mplayer -idx"
alias grep="grep --color=auto"
#alias irb="irb --simple-prompt"
alias battery="~/bin/battery.pl"

alias ls="ls -hF -a --color=auto"

alias abs="sudo abs"
alias shutdown="sudo shutdown -hP -t 0 now"
alias reboot="sudo reboot"
alias nitrogen="nitrogen ~/wallpapers"
alias clean="sudo pacman -Qdt && sudo pacman -Scc && sudo updatedb"
alias updatedb="sudo updatedb"
alias df="df -h"

# bash prompt styles
#PS1="[\[\e[37m\]\u\[\e[31m\]@\[\e[37m\]\h\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]] \$ "
#PS1="\[\e[36;1m\][\[\e[34;1m\]\w\[\e[36;1m\]]: \[\e[0m\]"
#PS1="\[\e[0m\][\[\e[0m\]\w\[\e[0m\]]: \[\e[0m\]"
#PS1="\[\e[0m\]\u \e[31m\]\w\[\e[0m\] "
PS1="\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]$ "

eval `dircolors -b ~/.dircolors`

# command history settings
export PATH="/opt/java/bin:$PATH"

# bash completion
complete -cf sudo         # sudo tab-completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
