#!/bin/bash

alias ls='ls --color=auto'
alias l='ls --color=auto -alv'
alias rgrep='grep --color=auto -RniP'
alias v='vim'
alias top='atop'
alias mv='mv -i'

# Git stuff
# To set up autocompletion for g: (http://titusd.co.uk/2010/08/29/use-g-as-an-alias-for-git-without-losing-autocompletion/)
# Add the line:
# complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null \
#            || complete -o default -o nospace -F _git g
#
# To /etc/bash_completion.d/git

alias g='git'
alias s='git status'
alias log='git log'
alias gg='git for-each-ref --sort=-committerdate refs/heads/ --format='"'"'%(refname)%09%(committername)%09%(committerdate)%09%(objectname:short)%09%(contents:subject)'"'"' | sed '"'"'s/refs\/heads\///g'"'"' | column -t -s '"$'\t'"' | head'
alias gcb='__git_ps1 "%s"'
alias psqlg='psql $(gcb)'


# Generate random pwd
alias pwdgen='gpg --gen-random --armor 1 9'

cws() {
    pushd /home/aaronb/code/www/moodle/$1/htdocs
}
