commandExists() {
  if hash $1 >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

directoryExists() {
  if [ -d "$1" ]; then
    return 0
  fi
  return 1
}

fileExists() {
  if [ -f "$1" ]; then
    return 0
  fi
  return 1
}

###############################################################################
###############################################################################
# INSTALL PROGRAMS
###############################################################################
###############################################################################

xcode() {
  if commandExists xcode-select; then
    echo xcode already installed
    return
  fi
  echo installing xcode...
  xcode-select --install
  echo done installing xcode...
}

installHomebrew() {
  if commandExists brew; then
    echo brew already installed
    return
  fi
  echo installing homebrew...
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew cask
  brew tap caskroom/versions
  brew tap caskroom/fonts
  echo done installing homebrew...
}

brewInstall() {
  brewAppsToInstall=(
  'coreutils'
  'wget --with-iri'
  'youtube-dl'
  'zsh'
  'trash'
  'fasd'
  'tmux'
  'tree'
  'the_silver_searcher'
  'findutils'
  'imagemagick'
  'git'
  'hub'
  'go --cross-compile-common'
  'cmake'
  'ctags-exuberant'
  'node'
  'ruby'
  'luajit'
  'vim --override-system-vi --with-luajit'
  'fzf'
  )

  echo installing brew apps...
  sudo chown -R $(whoami):admin /usr/local
  brew update
  brew upgrade --all

  for i in "${brewAppsToInstall[@]}"; do
    brew install $i
  done

  brew cleanup
  echo done install brew apps...
}

brewCaskInstall() {
  caskAppsToInstall=(
  'google-chrome'
  'google-chrome-canary'
  'bettertouchtool'
  'hyperswitch'
  'alfred'
  'iterm2-beta'
  'messenger'
  'sourcetree'
  'nvalt'
  'the-unarchiver'
  'f-lux'
  )

  echo installing homebrew cask apps...
  brew update

  for i in "${caskAppsToInstall[@]}"; do
    brew cask install $i
  done

  brew cleanup
  echo done installing homebrew cask apps...
}

installPrograms() {
  xcode
  installHomebrew
  brewInstall
  brewCaskInstall
}

###############################################################################
###############################################################################
# DOTFILES
###############################################################################
###############################################################################

dotfiles() {
  if directoryExists ~/.dotfiles; then
    echo .dotfiles already setup...
    return
  fi

  echo copy my dotfiles...
  git clone https://github.com/esayemm/.files.git ~/.dotfiles

  filesToSymlink=(
  'vimrc'
  'zshrc'
  'vim'
  'gitconfig'
  'npmrc'
  'tmux.conf'
  'tmux'
  'agignore'
  )

  for i in "${filesToSymlink[@]}"; do
    if [ ! -e ~/.$i ]; then
      echo symlinking $i...
      ln -s ~/.dotfiles/$i ~/.$i
    fi
  done

  echo done symlinking dotfiles...
}

###############################################################################
###############################################################################
# SHELL
###############################################################################
###############################################################################

setupBase16Shell() {
  if directoryExists ~/.config/base16-shell; then
    echo base16-shell already setup...
    return
  fi

  echo setting up base16-shell...
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

  echo done setting up base16-shell...
  echo ************************************************************************
  echo Still need to download base16 color schemes and use in iterm
  echo ************************************************************************
}

fonts() {
  if [ ! -e /Library/Fonts/ProggyCleanSZBP.tff ]; then
    cd ~/Downloads
    echo installing ProggyCleanSZBP font ...
    wget http://www.proggyfonts.net/wp-content/download/ProggyCleanSZBP.ttf.zip
    unzip ProggyCleanSZBP.ttf.zip
    mv ProggyCleanSZBP.ttf /Library/Fonts/
    echo done installing ProggyCleanSZBP font ...
  fi
}

setupShell() {
  setupBase16Shell
  fonts
}

###############################################################################
###############################################################################
# LANGUAGES
###############################################################################
###############################################################################

setupNodeEnv() {
  echo installing npm global packages...
  npm install -g gulp nodemon webpack
  echo done installing npm global packages...
}

setupLanguages() {
  setupNodeEnv
}

###############################################################################
###############################################################################
# VIM
###############################################################################
###############################################################################

vimPlug() {
  if fileExists ~/.vim/autoload/plug.vim; then
    echo plug.vim already installed
    return
  fi

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

vimSetup() {
  vimPlug
}

###############################################################################
###############################################################################
# MAIN
###############################################################################
###############################################################################

main() {
  installPrograms
  dotfiles
  setupShell
  setupLanguages
  vimSetup
}

main

printf "
  - Base 16 Color
    run command for your choice of color scheme

    base16 [tab complete]

  - fzf
    run /usr/local/opt/fzf/install

  All done!
"
