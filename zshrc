# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="arrow"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

# export JAVA_HOME=$(/usr/libexec/java_home)

# Load everything in zsh folder
for file in ~/.dotfiles/zsh/*
do
  [ -r "$file" ] && source "$file"
done
unset file

# Allow special keys
stty -ixon -ixoff

# Key Binding
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Programs
# Init fasd
eval "$(fasd --init auto)"

# User config
# NVM
# export NVM_DIR=$HOME/.nvm
# source $NVM_DIR/nvm.sh
# [ -s $HOME/.nvm/nvm.sh ]&& . $HOME/.nvm/nvm.sh

# source ~/npm/bin

# Go Paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Misc android
export PATH=~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:$PATH

# use private/env to store private env vars
# source ~/.dotfiles/private/env

# RVM
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

dockerup

# automatically add none default keys
if [ -e ~/.ssh/github_rsa ]; then
    ssh-add ~/.ssh/github_rsa;
fi
