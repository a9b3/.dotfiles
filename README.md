# dotfiles

For personal use.

## Setup

1. Create github ssh key

```
ssh-keygen -t ed25519 -C "email@gmail.com"
eval "$(ssh-agent -s)"
[ ! -f ~/.ssh/config ] && touch ~/.ssh/config && echo "
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
" >> ~/.ssh/config
ssh-add -K ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
```

[Add new SSH key to github account](https://github.com/settings/ssh/new), paste
content of public key here.

2. `git clone git@github.com:esayemm/.dotfiles.git $HOME/.dotfiles`

3. [Install direnv](https://direnv.net/docs/installation.html#from-binary-builds)

```
curl -sfL https://direnv.net/install.sh | bash
```

4. Install nix

```
curl -L https://nixos.org/nix/install | sh
```

5. Symlink shell.nix and envrc which will bootstrap the rest.

```
ln -s $HOME/.dotfiles/envrc $HOME/.envrc
ln -s $HOME/.dotfiles/shell.nix $HOME/shell.nix
```
