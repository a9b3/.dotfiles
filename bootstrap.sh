#!/usr/bin/env bash

# https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
# Ask for admin upfront
# sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

####################
# Util functions
####################
exists ()
{
  program=$1

  if hash $program >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

####################
# Init functions
####################
xcode ()
{
  echo installing xcode...

  if [[ $(xcode-select -p) == "/Applications/Xcode.app/Contents/Developer" ]]; then
    echo xcode already installed
  else
    xcode-select --install
  fi

  echo done installing xcode...
}

homebrew ()
{
  echo "installing homebrew..."

  if exists brew; then
    echo brew already installed
  else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask
    brew tap caskroom/versions
    brew tap caskroom/fonts
  fi

  echo "done installing homebrew..."
}

homebrewApps ()
{

  echo installing stuff through homebrew...
  sudo chown -R $(whoami):admin /usr/local
  brew update
  brew upgrade --all

  brewAppsToInstall=(
  'coreutils'
  'findutils'
  'wget --with-iri'
  'imagemagick'
  'tree'
  'trash'
  'youtube-dl'
  'zsh'
  'cmake'
  'vim --override-system-vi'
  'the_silver_searcher'
  'git'
  'ctags-exuberant'
  'mongodb'
  'node'
  'fasd'
  'ruby'
  )

  for i in "${brewAppsToInstall[@]}"; do
    brew install $i
  done

  brew cleanup
  echo done installing stuff through homebrew...
}

homebrewCaskApps ()
{
  echo installing homebrew cask apps...

  brew update

  caskAppsToInstall=(
  'google-chrome'
  'bettertouchtool'
  'hyperswitch'
  'alfred'
  'iterm2-beta'
  'messenger'
  'sourcetree'
  'nvalt'
  )

  for i in "${caskAppsToInstall[@]}"; do
    brew cask install $i
  done

  brew cleanup
  echo done installing homebrew cask apps...
}

dotfiles ()
{
  echo copy my dotfiles...

  if [ ! -e ~/.dotfiles ]; then
    git clone https://github.com/esayemm/.files.git ~/.dotfiles
  fi

  filesToSymlink=(
  'vimrc'
  'zshrc'
  'vim'
  'gitconfig'
  'npmrc'
  'tmux.conf'
  )

  for i in "${filesToSymlink[@]}"; do
    if [ ! -e ~/.$i ]; then
      echo symlinking $i...
      ln -s ~/.dotfiles/$i ~/.$i
    fi
  done

  echo done copying my dotfiles...
}

vimPlugins ()
{
  echo installing vim plugins...

  if [ ! -e ~/.vim/bundle ]; then
    mkdir ~/.vim/bundle
  fi

  cd ~/.vim/bundle

  reposToClone=(
  'https://github.com/Raimondi/delimitMate.git'
  'https://github.com/SirVer/ultisnips.git'
  'https://github.com/Valloric/YouCompleteMe.git'
  'https://github.com/airblade/vim-gitgutter.git'
  'https://github.com/bling/vim-airline-themes.git'
  'https://github.com/ctrlpvim/ctrlp.vim.git'
  'https://github.com/mattn/emmet-vim.git'
  'https://github.com/mxw/vim-jsx.git'
  'https://github.com/othree/javascript-libraries-syntax.vim.git',
  'https://github.com/pangloss/vim-javascript.git'
  'https://github.com/scrooloose/nerdtree.git'
  'https://github.com/terryma/vim-multiple-cursors.git'
  'https://github.com/tomtom/tcomment_vim.git'
  'https://github.com/tpope/vim-fugitive.git'
  'https://github.com/tpope/vim-surround'
  'https://github.com/easymotion/vim-easymotion.git'
  'https://github.com/terryma/vim-smooth-scroll.git'
  )

  regex="/([^/]+)\.git$"
  for i in "${reposToClone[@]}"; do
    if [[ $i =~ $regex ]]; then
      if [ ! -e ~/.vim/bundle/${BASH_REMATCH[1]} ]; then
        printf "cloning $i...\n"
        git clone $i
      else
        printf "$i already exists...\n"
      fi
    fi
  done

  # vim colors not really a plugin, just *.vim color files
  if [ ! -e ~/.vim/colors ]; then
    cd ~/.vim
    git clone https://github.com/flazz/vim-colorschemes.git
    cp -R ~/.vim/vim-colorschemes/colors ~/.vim
  fi

  build_file=~/.vim/bundle/YouCompleteMe/third_party/ycmd/build.py

  if [[ ! -f "$build_file" ]]; then
    echo compiling ycm...
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.py --clang-completer --tern-completer
    cd ~
    echo done compiling ycm...
  fi

  cd ~

  echo done installing vim plugins...
}

ohMyZsh ()
{
  if [ ! -e ~/.oh-my-zsh ]; then
    echo installing oh-my-zsh...
    cd ~
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    echo done installing oh-my-zsh...
  fi

  currShell=$(echo $SHELL)
  if [ $currShell != '/usr/local/bin/zsh' ]; then
    echo setting zsh as default shell...
    sudo echo $(which zsh) | tee -a /etc/shells
    sudo chsh -s $(which zsh)
    echo done setting zsh as default shell...
  fi
}

node ()
{
  printf "installing npm global packages...\n"
  npm install -g gulp grunt grunt-cli nodemon mocha webpack
  printf "done installing npm global packages...\n"
}

ruby ()
{
  if exists scss-lint; then
    printf "installing ruby gems...\n"
    gem install scss-lint
    printf "done installing ruby gems...\n"
  fi
}

fonts ()
{
  cd ~/Downloads

  if [ ! -e /Library/Fonts/ProggyCleanSZBP.tff ]; then
    printf "installing ProggyCleanSZBP font...\n"
    wget http://www.proggyfonts.net/wp-content/download/ProggyCleanSZBP.ttf.zip
    unzip ProggyCleanSZBP.ttf.zip
    mv ProggyCleanSZBP.ttf /Library/Fonts/
    printf "done installing ProggyCleanSZBP font...\n"
  fi
}

generateKeys ()
{
  if [ ! -e ~/.ssh/github_rsa ]; then
    printf "generating keys\n"
    cd ~
    ssh-keygen -t rsa -b 4096 -C "esayemm@gmail.com"
    printf "done generating keys\n"
  fi
}

docker ()
{
  cd ~/Downloads

  if [ ! $(docker-machine) ]; then
    printf "installing docker\n"
    wget https://github.com/docker/toolbox/releases/download/v1.9.1f/DockerToolbox-1.9.1f.pkg
    printf "done installing docker\n"
  fi

}

finished ()
{
  printf "

  Remember!
  $ pbcopy < ~/.ssh/id_rsa.pub
  * paste into github

  Test connection
  $ ssh -T git@github.com

  - iTerm color schemes
  https://github.com/mbadolato/iTerm2-Color-Schemes.git
  import *.itermcolors files

  - App Settings in ~/.dotfiles/appSettings/
  - iTerm2
  - BetterTouchTool

  - Run DockerToolbox installer
  - set docker.me in host file

  All done\n
  \n"

  open ~/Downloads
}

####################
# Immediately Invoke
####################
xcode
homebrew
homebrewApps
homebrewCaskApps
dotfiles
vimPlugins
ohMyZsh
node
fonts
generateKeys
docker
finished
