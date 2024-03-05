#!/bin/sh

if (( $EUID != 0 )); then
  echo "Please run as root"
  exit 1
else
  echo "I am ROOOOOT"
fi

# config
mirrors="
	fedora-workstation-repositories
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
"

repos="
	https://download.opensuse.org/repositories/shells:zsh-users:antigen/Fedora_Rawhide/shells:zsh-users:antigen.repo
"

packages="
	btop
	code
	discord
	gcc
	gh
	git
	java-latest-openjdk
	mangohud
	micro
	mupdf
	mpv
	neofetch
	obs-studio
	steam
	tldr
	virt-manager
	xclip
	zsh
"
#	texlive-scheme-full

remove_packages="
	akregator
	cheese
	dragon
	gnome-boxes
	gnome-maps
	gnome-tour
	gnome-weather
	elisa-player
	libreoffice-*
	kaddressbook
	kamaso
	kmahjongg
	kmines
	kmail
	kpat
	kolourpaint
	konversation
	korganizer
	rhythmbox
	simple-scan
	totem
	yelp
"

flatpaks="
	com.bitwarden.desktop
	md.obsidian.Obsidian
	org.onlyoffice.desktopeditors
	org.signal.Signal
	com.spotify.Client
"

# dnf
echo "[main]
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True

# custom
max_parallel_downloads=20
" > /etc/dnf/dnf.conf

# mirrors
dnf install -y $mirrors
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
dnf config-manager --disable google-chrome
dnf copr disable phracek/PyCharm
dnf config-manager --add-repo $repos
dnf groupupdate -y core

# packages
dnf remove -y $remove_packages
dnf update -y --refresh
dnf install -y $packages


flatpak update
flatpak install -y $flatpaks
sudo -u $SUDO_USER sh -c "wget -qO- https://sh.rustup.rs | sh -s -- -y"

# JetBrains toolbox
(
wget -cqO /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
tar -xzf /tmp/jetbrains-toolbox.tar.gz --directory=/tmp
/tmp/jetbrains*/jetbrains-toolbox
rm -r /tmp/jetbrains*
)&

# fonts
(
wget -cqO /tmp/CodeNewRoman.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CodeNewRoman.zip
unzip -q /tmp/CodeNewRoman.zip -x README.md license.txt -d /home/$SUDO_USER/.local/share/fonts
rm -r /tmp/CodeNewRoman*
)&

wait

# zsh
sudo -u $SUDO_USER sh -c "wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended"
curl -s https://ohmyposh.dev/install.sh | bash -s
curl -sL git.io/antigen > /usr/local/bin/antigen.zsh &
cp -r ./themes /home/$SUDO_USER/.config/ &
cp ./zshrc /home/$SUDO_USER/.zshrc &
cp ./aliases /home/$SUDO_USER/.config/ &

wait 
chsh -s $(which zsh) $SUDO_USER

read -p "Press any key to resume ..."
