#!/usr/bin/env bash

# https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
# Ask for admin upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
    if [[ $(brew) ]]; then
        echo "brew already installed"
    else
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    echo "done installing homebrew..."
}

homebrewApps ()
{
    echo installing stuff through homebrew...
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
        'https://github.com/ctrlpvim/ctrlp.vim.git'
        'https://github.com/scrooloose/nerdtree.git'
        'https://github.com/bling/vim-airline.git'
        'https://github.com/terryma/vim-multiple-cursors.git'
        'https://github.com/airblade/vim-gitgutter.git'
        'https://github.com/tpope/vim-fugitive.git'
        'https://github.com/tomtom/tcomment_vim.git'
        'https://github.com/SirVer/ultisnips.git'
        'https://github.com/tpope/vim-surround.git'
        'https://github.com/Valloric/YouCompleteMe.git'

        'https://github.com/mxw/vim-jsx.git'
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
        echo setting zsh as default shell...
        chsh -s /bin/zsh
    fi
}

node ()
{
    printf "installing nvm...\n"
    if [ ! -e ~/.nvm ]; then
        git clone https://github.com/creationix/nvm.git ~/.nvm
        cd ~/.nvm
        git checkout `git describe --abbrev=0 --tags`
        source ~/.nvm/nvm.sh
    fi
    printf "done installing nvm...\n"

    printf "installing latest node version via nvm...\n"
    nvm install node
    printf "done installing latest node version via nvm...\n"

    printf "installing npm global packages...\n"
    npm install -g gulp grunt grunt-cli
    printf "done installing npm global packages...\n"
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
        wget https://iterm2.com/downloads/stable/iTerm2-2_1_4.zip
        unzip iTerm2-2_1_4.zip
        sudo cp -r iTerm.app /Applications/
        printf "done installing iTerm2...\n"
    fi

    printf "done installing applications...\n"
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
