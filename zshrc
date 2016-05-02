# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="arrow"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

# Load everything in zsh folder
for file in ~/.dotfiles/zsh/*
do
  [ -r "$file" ] && source "$file"
done
unset file

# source secrets/env if it exists
[ -r "~/.dotfiles/secrets/env" ] && source "~/.dotfiles/secrets/env"

# Allow special keys
stty -ixon -ixoff

# Key Binding
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Programs
# Init fasd
eval "$(fasd --init auto)"

# Go Paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Misc android
export PATH=~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:$PATH

# Uses special alias to setup docker env
dockerup

# automatically add non default keys
if [ -e ~/.ssh/github_rsa ]; then
    ssh-add ~/.ssh/github_rsa;
fi
