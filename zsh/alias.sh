alias e="exit"
alias t="tmux"
alias mc="mc --nosubshell"
alias vi="nvim"
alias dd="dd status=progress"

alias z="source $HOME/.zshrc"
alias viz="nvim $HOME/.zshrc $HOME/.alias.sh $HOME/.gitconfig $HOME/.ssh/config"
alias viv="nvim $HOME/.config/nvim"
alias cursor="$HOME/.local/bin/cursor.AppImage --no-sandbox"
alias a='antigravity-ide --no-sandbox'

export EDITOR="nvim"

# Directories
alias cdv="cd $HOME/dev"
alias cdr="cd $HOME/dev/my-repos"
alias cdx="cd $HOME/dev/my-repos/reactiveX"
alias cdn="cd $HOME/dev/my-repos/nodejs-0-a-experto"
alias cdc="cd $HOME/dev/my-repos/courses"
alias cdz="cd $HOME/dev/zig"
alias cde="cd $HOME/dev/exercism"
alias cdb="cd $HOME/.local/bin"

alias cdphy="cd $HOME/dev/physis"
alias cdp2w="cd $HOME/dev/physis/phy2web"
alias cdp2s="cd $HOME/dev/physis/phy2services"
alias cdp2d="cd $HOME/dev/physis/physisdesktop"

alias cds="cd $HOME/dev/SATELLITES/satellites"

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
