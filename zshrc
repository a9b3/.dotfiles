# something in antigen uses gnu-sed, gsed is from brew install gnu-sed, doesn't
# hurt to have this as a default anyway
alias sed=gsed

[[ ! -d ~/.antigen ]] && git clone https://github.com/zsh-users/antigen.git ~/.antigen
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme arrow

antigen bundles <<EOBUNDLES
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
EOBUNDLES

antigen apply

# Allow special keys
stty -ixon -ixoff

# Key Binding
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
eval "$(fasd --init auto)"

# Load everything in secrets and zsh folder
for file in ~/.dotfiles/{secrets,zsh}/*; do
  [[ -r "$file" ]] && source "$file"
done
unset file
