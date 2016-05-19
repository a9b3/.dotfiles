# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="arrow"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew zsh-syntax-highlighting)

# Allow special keys
stty -ixon -ixoff

source $ZSH/oh-my-zsh.sh

# Load everything in zsh folder
for file in ~/.dotfiles/zsh/*
do
  [ -r "$file" ] && source "$file"
done
unset file

# source secrets/env if it exists
# source "~/.dotfiles/secrets/env"
[ -r ~/.dotfiles/secrets/env ] && source ~/.dotfiles/secrets/env || echo "no secret envs"

# Key Binding
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Programs
# Init fasd
eval "$(fasd --init auto)"

# Uses special alias to setup docker env
dockerup

# automatically add non default keys
if [ -e ~/.ssh/github_rsa ]; then
    ssh-add ~/.ssh/github_rsa;
fi

# The next line updates PATH for the Google Cloud SDK.
source '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc'
