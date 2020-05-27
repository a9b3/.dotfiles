# ---------------------------------------
# Plugin Manager
# ---------------------------------------

# Load antigen if it doesn't exist
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


# ---------------------------------------
# Init
# ---------------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fasd --init auto)"

# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
# use bash completions
autoload -U +X bashcompinit && bashcompinit


# ---------------------------------------
# Misc
# ---------------------------------------

# user defined zsh functions/aliases etc.
for file in ~/.dotfiles/{secrets,zsh}/*; do
  [[ -r "$file" ]] && source "$file"
done
unset file

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
