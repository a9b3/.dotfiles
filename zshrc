[[ ! -d ~/.antigen ]] && git clone https://github.com/zsh-users/antigen.git ~/.antigen
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme arrow

antigen bundles <<EOBUNDLES
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
EOBUNDLES

antigen apply

# load everything in secrets and zsh folder
for file in ~/.dotfiles/{secrets,zsh}/*; do
  [[ -r "$file" ]] && source "$file"
done
unset file

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
