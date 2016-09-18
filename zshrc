##############################################################################
# ANTIGEN
##############################################################################

# something in antigen uses gnu-sed, gsed is from brew install gnu-sed, doesn't
# hurt to have this as a default anyway
alias sed=gsed

[[ ! -d ~/.antigen ]] && git clone https://github.com/zsh-users/antigen.git ~/.antigen
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme robbyrussell/oh-my-zsh themes/arrow.zsh-theme

# zsh-users/zsh-history-substring-search

antigen bundles <<EOBUNDLES
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  jimhester/per-directory-history
EOBUNDLES

antigen apply

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

BASE16_SHELL=$HOME/.config/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
