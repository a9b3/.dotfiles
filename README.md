# Dotfiles

Dotfiles managed by home-manager.

## Quick Start

1. [Setup github ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. `git clone git@github.com:esayemm/.dotfiles.git $HOME/.dotfiles`

3. [Install nix](https://docs.determinate.systems/)

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

## How It Works

Home Manager manages everything, including sourcing conf files and managing
system packages. Any updates should go through home.nix

## Common Tasks

### Upgrading System Packages

Quick primer: nixpkgs is a snapshot of all packages versions. flake.nix lets you
declare nixpkgs versions used semantically (e.g. stable, unstable) and
flake.lock will pin the specific version.

There is no way to upgrade a single package, you must update nixpkgs as a whole
which will in turn update all packages.

```
nix flake lock --update-input nixpkgs
# or
nix flake lock --update-input nixpkgs-unstable
```
