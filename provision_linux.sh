# Run with the following command
#
#   ssh -t user@server 'bash -s' <(wget -qO- https://raw.githubusercontent.com/esayemm/dotfiles/master/provision.sh)
#

echo "Enter name"

read create_user

# Create user
adduser $create_user
usermod -aG sudo $create_user
sudo passwd $create_user

# Allow ssh
ufw allow OpenSSH
ufw enable

# Move ssh keys
rsync --archive --chown=$create_user:$create_user ~/.ssh /home/$create_user

# Assume created user
su - $create_user

sudo chsh -s $(which zsh)

# Provision with dotfiles and home-manager
git clone git@github.com:esayemm/.dotfiles.git $HOME/.dotfiles

curl -L https://nixos.org/nix/install | sh

. $HOME/.nix-profile/etc/profile.d/nix.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

rm $HOME/.config/nixpkgs/home.nix
ln -s $HOME/.dotfiles/home.nix $HOME/.config/nixpkgs/home.nix

home-manager switch
