# Dotfiles

## Installation

On new system.

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

[https://docs.determinate.systems/](https://docs.determinate.systems/)

4. Install home-manager

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
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
make
```

## Upgrading System Packages

Everything is managed by home-manager. Nix is used to manage system packages,
nix manages dependencies as a snapshot of the entire universe of packages,
as an intended effect it is not encouraged to upgrade any individual package
instead you should upgrade the entire system. However it is still possible.
Flakes and the generated lock file are used to pin the nix versions, you can use
flake overlays to update individual packages by providing a new nix repository for
the package individually.

**AdHoc**

```
nix-shell -p nixpkgs#neovim
```

**Flake Overlays**

To update the Neovim package in your Nix flake, you can modify the `flake.nix`
file to point to a newer commit of the `nixpkgs` repository. Replace
`<new_commit>` with the actual commit hash you want to use.

```
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-unstable.url = "github:NixOS/nixpkgs?rev=<new_commit>";
  };

  outputs = { self, nixpkgs, neovim-unstable, ... }:
  let
    pkgs = import nixpkgs { system = "aarch64-darwin"; overlays = [
      (final: prev: {
        neovim = neovim-unstable.legacyPackages.aarch64-darwin.neovim;
      })
    ]; };
  in
  {
    homeConfigurations.es = ...;
  };
}
```
