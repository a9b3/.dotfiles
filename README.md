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

3. Install nix

```
curl -L https://nixos.org/nix/install | sh
```

4. Install home-manager

```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

5. Symlink home.nix

```
rm $HOME/.config/nixpkgs/home.nix
ln -s $HOME/.dotfiles/home.nix $HOME/.config/nixpkgs/home.nix
```

6. Activate home-manager

```
home-manager switch
```

7. Install vim plugs

```
vim
# inside vim
:PlugInstall
```
