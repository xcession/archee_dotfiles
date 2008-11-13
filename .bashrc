#
# ~/.bashrc
#

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -a'
alias grep='grep --color=auto'
alias abs='sudo abs'
alias shutdown='sudo shutdown -hP -t 0 now'
alias reboot='sudo reboot'
alias nitrogen='nitrogen ~/wallpapers'
alias clean='sudo pacman -Qdt && sudo pacman -Scc'
alias df='df -h'

export PATH="/opt/java/bin:$PATH"

#PS1='\[\e[0;32m\]\u@\h \W]\$ '
#PS1='\[\e[0;31m\][\[\e[0;37m\]\u\[\e[0;36m\]@\[\e[0;37m\]\h\[\e[0;31m\]] \[\e[0;33m\][\W] \[\e[0;33m\]:\[\e[0m\] '
#PS1='\[\e[0m\][\u\[\e[0;31m\]@\[\e[0m\]\h:\[\e[0;33m\]\w\[\e[0m\]] \[\e[0m\]$\[\e[0;33m\] '
PS1='\[\e[0m\][\u\[\e[0;36m\]@\[\e[0m\]\h:\[\e[0;36m\]\w\[\e[0m\]] \[\e[0m\]$\[\e[0;36m\] '

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
