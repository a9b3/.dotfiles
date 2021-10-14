# Run with the following command
#
#   ssh -t root@137.184.127.181 'bash -s' <(wget -qO- https://raw.githubusercontent.com/a9b3/.dotfiles/master/provision_linux.sh)
#
# or ssh in as root and run
#
#   bash <(curl -s https://raw.githubusercontent.com/a9b3/.dotfiles/master/provision_linux.sh)
#

echo "Enter name"
read create_user

# Create user
adduser $create_user
usermod -aG sudo $create_user
# sudo passwd $create_user

# Move ssh keys
rsync --archive --chown=$create_user:$create_user ~/.ssh /home/$create_user

sudo chsh -s $(which zsh)

# Assume created user
su - $create_user

echo "Enter email"
read create_user_email

ssh-keygen -t rsa -b 4096 -C "$create_user_email"

echo "Copy the public key and add to https://github.com/settings/ssh/new"
echo ""
cat $HOME/.ssh/*.pub
echo ""
read -n 1 -s -r -p "Press any key to continue"

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
