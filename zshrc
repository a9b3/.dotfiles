# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="arrow"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

export JAVA_HOME=$(/usr/libexec/java_home)

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
# init z   https://github.com/rupa/z
# . ~/code/z/z.sh
. /usr/local/etc/profile.d/z.sh

# User config
# NVM
export NVM_DIR=$HOME/.nvm
source $NVM_DIR/nvm.sh
[ -s $HOME/.nvm/nvm.sh ]&& . $HOME/.nvm/nvm.sh
export PATH="$PATH:$HOME/.node/bin"

# Go Paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Misc android
export PATH=/Applications/Android\ Studio.app/sdk/tools:/Applications/Android\ Studio.app/sdk/platform-tools:$PATH


# RVM
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
