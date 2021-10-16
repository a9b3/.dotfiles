# Run with the following command
#
#   ssh -t root@137.184.127.181 'bash -s' <(wget -qO- https://raw.githubusercontent.com/a9b3/.dotfiles/master/provision_linux.sh)
#
# or ssh in as root and run
#
#   bash <(curl -s -H "Cache-Control: no-cache" https://raw.githubusercontent.com/a9b3/.dotfiles/master/provision_linux.sh)
#
# To remove a user run this
#
#   deluser newuser
#

# exit when any command fails
set -e

echo "Enter email"
read create_user_email
HOME_DIR="$HOME"

if [[ ! -f "$HOME_DIR/.ssh/id_rsa.pub" ]]; then
  ssh-keygen -t rsa -b 4096 -C "$create_user_email"
fi

echo ""
echo ""
echo "Copy the public key and add to https://github.com/settings/ssh/new"
echo ""
echo ""
cat "$HOME_DIR/.ssh/id_rsa.pub"

echo ""
echo ""
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""

# clone dotfiles and install nix
# Provision with dotfiles and home-manager
if [[ ! -d "$HOME_DIR/.dotfiles" ]]; then
  git clone git@github.com:esayemm/.dotfiles.git "$HOME_DIR/.dotfiles"
fi

# home-manager
if ! which nix &> /dev/null; then
  curl -L https://nixos.org/nix/install | sh
fi

. $HOME_DIR/.nix-profile/etc/profile.d/nix.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

if [[ -f "$HOME_DIR/.config/nixpkgs/home.nix" ]]; then
  rm "$HOME_DIR/.config/nixpkgs/home.nix"
fi

ln -s "$HOME_DIR/.dotfiles/home.nix" "$HOME_DIR/.config/nixpkgs/home.nix"

home-manager switch

sudo chsh -s $(which zsh)
