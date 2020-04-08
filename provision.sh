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

function print_header() {
  printf "===============================\n"
  printf "$1\n"
  printf "===============================\n"
}

function install_xcode() {
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
    brew list "$line" >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      printf "$line already exists\n"
    else
      printf "Installing $line\n"
      brew install "$line"
    fi
  done < ./brew/leaves

  while read line; do
    brew cask list "$line" >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      printf "$line already exists\n"
    else
      printf "Installing $line\n"
      brew cask install "$line"
    fi
  done < ./brew/cask_list
}

# Save brew and brew cask programs into files.
function brew_save() {
  brew leaves > ./brew/leaves
  brew cask list > ./brew/cask_list
}

function setup_env() {
  # First make sure symlinks exists
  files_to_symlink=(
    'gitconfig'
    'rgignore'
    'tmux.conf'
    'vim'
    'vimrc'
    'zshrc'
  )

  for i in "${files_to_symlink[@]}"; do
    if [[ ! -e ~/.$i ]]; then
      printf "symlinking $i\n"
      ln -s ./$i ~/.$i
    else
      printf "$i already symlinked\n"
    fi
  done

  # install my favorite font
  if [[ ! -e /Library/Fonts/ProggyCleanSZBP.tff ]]; then
    printf "Installing ProggyClean\n"
    cd ~/Downloads
    wget http://www.proggyfonts.net/wp-content/download/ProggyCleanSZBP.ttf.zip
    unzip ProggyCleanSZBP.ttf.zip
    mv ProggyCleanSZBP.ttf /Library/Fonts/
  else
    printf "ProggyClean already installed\n"
  fi

  # ensure zsh is the default shell
  if [[ "$SHELL" != "/bin/zsh" ]]; then
    printf "making zsh default shell\n"
    chsh -s /usr/local/bin/zsh
  else
    printf "zsh already default shell\n"
  fi
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
    print_header "checking if xcode exists"
    install_xcode
    print_header "checking if brew exists"
    install_homebrew
    print_header "installing brew packages"
    brew_install
    print_header "setting up symlinks"
    setup_env
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
