# ---------------------------------------
# Plugin Manager
# ---------------------------------------

# Load antigen if it doesn't exist
[[ ! -d ~/.antigen ]] && git clone https://github.com/zsh-users/antigen.git ~/.antigen
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  Aloxaf/fzf-tab
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
  virtualenvwrapper
  docker
  docker-compose
  git
  brew
  history
  node
  npm
  kubectl
EOBUNDLES

antigen apply


# ---------------------------------------
# Init
# ---------------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fasd --init auto)"

# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
# use bash completions
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit


# ---------------------------------------
# Misc
# ---------------------------------------

# user defined zsh functions/aliases etc.
# git-prompt.sh is used by prompt, so source this first
source ~/.dotfiles/zsh/git-prompt.sh
for file in ~/.dotfiles/{secrets,zsh}/*; do
  [[ -r "$file" ]] && source "$file"
done
unset file

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

[[ -f '/usr/local/bin/virtualenvwrapper.sh' ]] && source /usr/local/bin/virtualenvwrapper.sh

# temporary solution to get kubectl autocomplete
source <(kubectl completion zsh)
if [ -e /home/sam/.nix-profile/etc/profile.d/nix.sh ]; then . /home/sam/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
