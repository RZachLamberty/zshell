alias ls="ls --color=tty"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi
alias ll='ls -alhF'

alias em='emacs -nw'