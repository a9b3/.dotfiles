##############################################################################
# ANTIGEN
##############################################################################

# something in antigen uses gnu-sed, gsed is from brew install gnu-sed, doesn't
# hurt to have this as a default anyway
alias sed=gsed

[[ ! -d ~/.antigen ]] && git clone https://github.com/zsh-users/antigen.git ~/.antigen
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
# antigen theme robbyrussell/oh-my-zsh themes/arrow.zsh-theme
antigen theme robbyrussell/oh-my-zsh themes/minimal.zsh-theme

# zsh-users/zsh-history-substring-search

antigen bundles <<EOBUNDLES
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
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

export PATH="$HOME/.yarn/bin:$PATH"
