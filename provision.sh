#!/bin/bash

function commandExists() {
  which "$1" > /dev/null
}

function directoryExists() {
  if [[ -d "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function fileExists() {
  if [[ -f "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function xcode() {
  if ! commandExists xcode-select; then
    xcode-select --install
  fi
}

function installHomebrew() {
  if ! commandExists brew; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask
    brew tap caskroom/versions
    brew tap caskroom/fonts
  fi
}

function brewInstall() {
  brew install $(< ./brewleaves)
}

function brewCaskInstall() {
  brew cask install $(< ./brewcasklist)
}

function setupEnv() {
  # clone my dotfiles and symlink the config files
  if ! directoryExists ~/.dotfiles; then
    git clone https://github.com/esayemm/.files.git ~/.dotfiles

    filesToSymlink=(
    'vimrc'
    'zshrc'
    'vim'
    'gitconfig'
    'tmux.conf'
    'tmux'
    )

    for i in "${filesToSymlink[@]}"; do
      if [[ ! -e ~/.$i ]]; then
        ln -s ~/.dotfiles/$i ~/.$i
      fi
    done
  fi

  # install my favorite font
  if [[ ! -e /Library/Fonts/ProggyCleanSZBP.tff ]]; then
    cd ~/Downloads
    wget http://www.proggyfonts.net/wp-content/download/ProggyCleanSZBP.ttf.zip
    unzip ProggyCleanSZBP.ttf.zip
    mv ProggyCleanSZBP.ttf /Library/Fonts/
  fi

  # ensure zsh is the default shell
  if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s /usr/local/bin/zsh
  fi
}

function setupNodeEnv() {
  packages=(
  'n'
  )

  for i in "${packages[@]}"; do
    if !commandExists $i; then
      npm install -g $i
    fi
  done
}

xcode
installHomebrew
brew update
brewInstall
brewCaskInstall
brew cleanup
setupEnv
setupNodeEnv
