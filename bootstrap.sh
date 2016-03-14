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
  'https://github.com/othree/javascript-libraries-syntax.vim.git',
  'https://github.com/SirVer/ultisnips.git'
  'https://github.com/Valloric/YouCompleteMe.git'
  'https://github.com/airblade/vim-gitgutter.git'
  'https://github.com/bling/vim-airline-themes.git'
  'https://github.com/ctrlpvim/ctrlp.vim.git'
  'https://github.com/mattn/emmet-vim.git'
  'https://github.com/mxw/vim-jsx.git'
  'https://github.com/pangloss/vim-javascript.git'
  'https://github.com/scrooloose/nerdtree.git'
  'https://github.com/terryma/vim-multiple-cursors.git'
  'https://github.com/tomtom/tcomment_vim.git'
  'https://github.com/tpope/vim-fugitive.git'
  'https://github.com/tpope/vim-surround'
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

  cd ~

  echo done installing vim plugins...
}

ycm ()
{
  build_file=~/.vim/bundle/YouCompleteMe/third_party/ycmd/build.py

  if [[ ! -f "$build_file" ]]; then
    echo compiling ycm...
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.py --clang-completer
    cd ~
    echo done compiling ycm...
  fi
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
    echo $(which zsh) | tee -a /etc/shells
    sudo chsh -s $(which zsh)
    echo done setting zsh as default shell...
  fi
}

node ()
{
  printf "installing npm global packages...\n"
  npm install -g gulp grunt grunt-cli nodemon mocha
  printf "done installing npm global packages...\n"
}

ruby ()
{
  if [ ! scss-lint ]; then
    printf "installing ruby gems...\n"
    gem install scss-lint
    printf "done installing ruby gems...\n"
  fi
}

applications ()
{
  printf "installing applications...\n"
  cd ~/Downloads

  if [ ! -e /Applications/Google\ Chrome.app ]; then
    printf "installing chrome...\n"
    wget https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
    open googlechrome.dmg
    sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
    printf "done installing chrome...\n"
  fi

  if [ ! -e /Applications/Alfred\ 2.app ]; then
    printf "installing alfred...\n"
    wget https://cachefly.alfredapp.com/Alfred_2.8.1_425.zip
    unzip Alfred_2.8.1_425.zip
    sudo cp -r Alfred\ 2.app /Applications/
    printf "done installing alfred...\n"
  fi

  if [ ! -e /Applications/iTerm.app ]; then
    printf "installing iTerm2...\n"
    wget https://iterm2.com/downloads/beta/iTerm2-2_9_20160206.zip
    unzip iTerm2-2_9_20160206.zip
    sudo cp -r iTerm.app /Applications/
    printf "done installing iTerm2...\n"
  fi

  if [ ! -e /Applications/BetterTouchTool.app ]; then
    printf "installing BetterTouchTools\n"
    wget http://bettertouchtool.net/BetterTouchTool.zip
    unzip BetterTouchTool.zip
    sudo cp -r BetterTouchTool.app /Applications/
    printf "done installing BetterTouchTools\n"
  fi

  if [ ! -e /Applications/HyperSwitch.app ]; then
    printf "installing HyperSwitch\n"
    wget https://bahoom.com/hyperswitch/HyperSwitch.zip
    unzip HyperSwitch.zip
    sudo cp -r HyperSwitch.app /Applications/
    printf "done installing HyperSwitch\n"
  fi

  if [ ! -e /Applications/Messenger.app ]; then
    printf "installing Messenger\n"
    wget https://github.com/Aluxian/Facebook-Messenger-Desktop/releases/download/v1.4.3/Messenger.dmg
    open Messenger.dmg
    sudo cp -r /Volumes/Messenger/Messenger.app /Applications/
    printf "done installing Messenger\n"
  fi

  if [ ! -e /Applications/SourceTree.app ]; then
    printf "installing SourceTree\n"
    wget http://downloads.atlassian.com/software/sourcetree/SourceTree_2.1.dmg
    open SourceTree_2.1.dmg
    sudo cp -r /Volumes/SourceTree/SourceTree.app /Applications/
    printf "done installing SourceTree\n"
  fi

  if [ ! -e /Applications/nvALT.app ]; then
    printf "installing nvALT\n"
    wget http://abyss.designheresy.com/nvaltb/nvalt2.2b106.zip
    unzip nvalt2.2b106.zip
    sudo cp -r nvALT.app /Applications/
    printf "done installing nvALT\n"
  fi

  printf "done installing applications...\n"
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

projectFolder ()
{
  if [ ! -e ~/Projects ]; then
    mkdir ~/Projects
    cd ~/Projects

    if [ ! -e ~/Projects/esayemm ]; then
      mkdir esayemm
      cd esayemm
      git clone https://github.com/esayemm/profile-manager-cli.git
      cd profile-manager-cli
      npm link
      cd ..
      cd ..
    fi

    if [ ! -e ~/Projects/sandbox ]; then
      mkdir sandbox
    fi
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

xcode
homebrew
homebrewApps
dotfiles
vimPlugins
ycm
ohMyZsh
node
applications
fonts
projectFolder
generateKeys
docker
finished
