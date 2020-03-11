#!/bin/bash

alias toolkit='code ~/dev/toolkit'
alias aliases='code ~/dev/toolkit/aliases.sh'

# Can just put a ref to this in ~/.bashrc etc: source ~/dev/wyntuition.github.io/aliases.sh
shopt -s expand_aliases

alias src-alias="source ~/dev/todo/toolbox/aliases.sh"

alias todo='cd ~/dev/todo && code .'

alias h="history"

## Use a long listing format ##
alias ll='ls -la'\

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

alias ports='netstat -tulanp'

alias gitl='git log --graph --decorate --pretty=oneline --abbrev-commit'
# list branches sorted by last modified
alias gitb="git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"

alias gp='git pull'
alias gp='git pull origin master'
alias gitl='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gitc='git add . && git commit -am'
alias gitpa='~/dev/todo/toolbox/git-pull-all.sh'
alias gco='git checkout'
alias gcom='git checkout master'
alias gpm='git pull origin master'
alias gfm='git fetch origin master:master'
alias gitrs='git reset --sort ~HEAD'
alias gmg=$GOPATH/bin/go-many-git

alias dps="docker ps --format 'table {{.Names}}\\t{{.Image}}\\t{{.RunningFor}} ago\\t{{.Status}}\\t{{.Command}}'"
alias di="docker images ls --format 'table {{.Repository}}\\t{{.Tag}}\\t{{.ID}}\\t{{.Size}}'"

alias awsw='docker run --rm -t $(tty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "$(pwd):/project" mesosphere/aws-cli'

alias sshkg='ssh-keygen -t rsa -b 4096 -C "test@email.com"'

## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
#alias ij=open -a \"IntelliJ IDEA CE\"

alias lsof-ssh='sudo lsof -i -n  | grep ssh'
alias sshk='pkill ssh' # Kill all ssh tunnels

## ssh tunnelling using ssh-bastion-tunnel scripts (github.com/wyntuition/toolbox)
# alias ssht='cd ~/dev/toolbox/ssh-bastion-tunnel && ./ssh-bastion-setup'
# alias sshedit='code ~/dev/toolbox/ssh-bastion-tunnel/.env-bastion'
# alias sshe='source ~/dev/toolbox/ssh-bastion-tunnel/.env-bastion'
# alias bastion='ssh -i ~/.ssh/pk.pem ubuntu@$BASTION_IP'