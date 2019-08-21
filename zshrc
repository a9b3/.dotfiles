DISABLE_AUTO_TITLE="true"

[[ ! -d ~/.antigen ]] && git clone https://github.com/zsh-users/antigen.git ~/.antigen
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme sorin

antigen bundles <<EOBUNDLES
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
EOBUNDLES

antigen apply

# load everything in secrets and zsh folder
for file in ~/.dotfiles/{secrets,zsh}/*; do
  [[ -r "$file" ]] && source "$file"
done
unset file

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fasd --init auto)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

# Use pyenv to set the default python
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  # brew install pyenv-virtualenv
  eval "$(pyenv virtualenv-init -)"
fi
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
