alias e="exit"
alias t="tmux"
alias mc="mc --nosubshell"
alias vi="nvim"
alias dd="dd status=progress"

alias z="source $HOME/.zshrc"
alias viz="nvim $HOME/.zshrc $HOME/.alias.sh $HOME/.gitconfig $HOME/.ssh/config"
alias viv="nvim $HOME/.config/nvim"
alias a='antigravity-ide --no-sandbox'

alias cdv="cd $HOME/development"
alias cdb="cd $HOME/.local/bin"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Better defaults
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias ll="ls -lhF --color=auto"
alias la="ls -lahF --color=auto"
alias mkdir="mkdir -p"

function l. { ( if test -d "$1";  then cd $1;  fi  &&  ls -ldF .[^\.]*; ); }
