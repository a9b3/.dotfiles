#!/bin/bash
set -e

function command_exists() {
  which "$1" > /dev/null
}

function dir_exists() {
  if [[ -d "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function xcode() {
  if ! command_exists xcode-select; then
    xcode-select --install
  fi
}

# Install brew if it isn't installed.
function install_homebrew() {
  if ! command_exists brew; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask
    brew tap caskroom/versions
    brew tap caskroom/fonts
  fi
}

# Install brew and brew cask programs if they don't already exist.
function brew_install() {
  while read line; do
    brew list "$line" || brew install "$line"
  done < ./brew/leaves

  while read line; do
    brew cask list "$line" || brew cask install "$line"
  done < ./brew/cask_list
}

# Save brew and brew cask programs into files.
function brew_save() {
  brew leaves > ~/.dotfiles/brew/leaves
  brew cask list > ~/.dotfiles/brew/cask_list
}

function setup_env() {
  # clone my dotfiles and symlink the config files
  if ! dir_exists ~/.dotfiles; then
    git clone https://github.com/esayemm/.files.git ~/.dotfiles
  fi

  files_to_symlink=(
    'alacritty.yml'
    'gitconfig'
    'rgignore'
    'tmux'
    'tmux.conf'
    'vim'
    'vimrc'
    'zshrc'
  )

  for i in "${files_to_symlink[@]}"; do
    if [[ ! -e ~/.$i ]]; then
      ln -s ~/.dotfiles/$i ~/.$i
    fi
  done

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

function setup_node_env() {
  packages=(
    'n'
  )

  for i in "${packages[@]}"; do
    if !command_exists $i; then
      npm install -g $i
    fi
  done
}

# Print the help menu
function print_help() {
  printf "Provide a command after this script:\n\n"
  printf "update                      Installs dependencies\n"
  printf "save                        Save brew deps\n"
  printf "help                        Print help\n"
  printf "\n"
}

COMMAND=$1
case "$COMMAND" in
  # All functions in this step should be idempotent.
  update)
    xcode
    install_homebrew
    brew update
    brew_install
    brew cleanup
    setup_env
    setup_node_env
    ;;

  save)
    brew_save
    ;;

  help)
    print_help
    ;;

  *)
    print_help
    if [ ! -z "$COMMAND" ] ; then
      fail "Unknown command: $COMMAND"
    fi
    ;;
esac
