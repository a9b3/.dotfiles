# Standard for installing system binaries required by this project.
#
# Consume this file via nix-shell.
# e.g.
# nix-shell shell.nix
#
# pinning version to https://github.com/NixOS/nixpkgs/commit/7e9b0dff974c89e070da1ad85713ff3c20b0ca97
# version: nixos-21.05
#
# Search for available nixpkgs.
# https://search.nixos.org/packages?channel=21.05
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/21.05.tar.gz") {} }:

# mkShell creates a nix derivation consumed by nix-shell
pkgs.mkShell {
  shellHook = ''
  # Symlink files to $HOME
  [ ! -f ~/.envrc ] && ln -s "$HOME/.dotfiles/envrc" "$HOME/.envrc"
  [ ! -f ~/.rgignore ] && ln -s "$HOME/.dotfiles/rgignore" "$HOME/.rgignore"
  [ ! -f ~/.gitconfig ] && ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
  [ ! -f ~/.zshrc ] && ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
  [ ! -f ~/.tmux.conf ] && ln -s "$HOME/.dotfiles/tmux.conf" "$HOME/.tmux.conf"
  [ ! -f ~/.alacritty.yml ] && ln -s "$HOME/.dotfiles/conf/alacritty.yml" "$HOME/.alacritty.yml"
  [ ! -d ~/.vim ] && ln -s "$HOME/.dotfiles/vim" "$HOME/.vim"
  [ ! -d ~/.config/nvim ] && ln -s "$HOME/.dotfiles/vim" "$HOME/.config/nvim"

  # Install setup node provider for neovim using root npm
  # Intentionally set this because m1 mac doesn't work with /usr/local because
  # its protected.
  npm config set prefix "$HOME/.node_modules"
  export PATH="$PATH:$HOME/.node_modules/bin"
  [ ! -d $(npm root -g)/neovim ] && npm install -g neovim
  '';

  buildInputs = let
    # Custom pkg for neovim using nightly
    neovimKey = with pkgs; {
      "x86_64-darwin" = {
        "key" = "macos";
        "output" = "osx64";
        "sha256" = "52d5f20cb0438dfa3cb4953ba733532b3164beed6499d70332950b0ad4c6b48c";
      };
      "x86_64-linux" = {
        "key" = "linux64";
        "output" = "linux64";
        "sha256" = "bd7054fc9eab2c95064424d3925f9c5c9641c47719804b51df1d2cc2e828193e";
      };
    }."${stdenv.system}";
    neovim = with pkgs; stdenv.mkDerivation rec {
      name = "neovim";
      src = fetchurl {
        url = "https://github.com/neovim/neovim/releases/download/nightly/nvim-${neovimKey.key}.tar.gz";
        sha256 = "${neovimKey.sha256}";
      };
      # Need to provide a custom builder since the default assumes there's a
      # makefile in the source
      builder = pkgs.writeText "builder.sh" ''
        source $stdenv/setup
        mkdir -p $out/bin
        tar zxvf $src
        cp -r nvim-${neovimKey.output}/* $out
        chmod +x $out/bin/nvim
      '';
    };
    # Custom python installation with global packages installed.
    my-python-packages = python-packages: with python-packages; [
      pynvim
     # other python packages you want
    ];
    python-with-my-packages = pkgs.buildPackages.python3.withPackages my-python-packages;
  in
  [
    # SYSTEM
    pkgs.buildPackages.tmux
    pkgs.buildPackages.exa
    pkgs.buildPackages.fzf
    pkgs.buildPackages.fasd
    pkgs.buildPackages.ripgrep
    pkgs.buildPackages.jq
    pkgs.buildPackages.httpie
    pkgs.buildPackages.fd
    pkgs.buildPackages.diff-so-fancy
    pkgs.buildPackages.docker

    # NODE
    pkgs.buildPackages.nodejs

    # PYTHON
    python-with-my-packages

    # VIM
    neovim

    # GOLANG
    pkgs.buildPackages.go
  ];
}
