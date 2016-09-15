##############################################################################
# oh-my-zsh
##############################################################################

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="arrow"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

##############################################################################
# key bindings
##############################################################################

# Allow special keys
stty -ixon -ixoff

# Key Binding
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

##############################################################################
# path stuff
##############################################################################

export PATH=$PATH:~/opt/terraform
export PATH=$PATH:~/opt/packer
export PATH=$PATH:~/opt/kubectl
export PATH=$PATH:~/opt/

##############################################################################
# source files
##############################################################################

# Load everything in zsh folder
for file in ~/.dotfiles/zsh/*
do
  [ -r "$file" ] && source "$file"
done
unset file

# source "~/.dotfiles/secrets/env"
for file in ~/.dotfiles/secrets/*
do
  [ -r "$file" ] && source "$file"
done
unset file

# Programs
# Init fasd
if which fasd >/dev/null; then
  eval "$(fasd --init auto)"
fi

# hub alias for -s instructions
if which hub >/dev/null; then
  eval "$(hub alias -s)"
  alias git='hub'
fi

# To make docker work need env variables
if which docker-machine >/dev/null; then
  eval "$(docker-machine env default)"
fi

# automatically add non default keys
if [ -e ~/.ssh/github_rsa ]; then
  ssh-add ~/.ssh/github_rsa;
fi

# # The next line updates PATH for the Google Cloud SDK.
# source '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc'
#
# # The next line enables shell command completion for gcloud.
# source '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc'
