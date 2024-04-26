#!/bin/sh

if (( $EUID != 0 )); then
  echo "Please run as root"
  exit 1
else
  echo "I am ROOOOOT"
fi

# config
mirrors="
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
"

repos="
	https://download.opensuse.org/repositories/shells:zsh-users:antigen/Fedora_Rawhide/shells:zsh-users:antigen.repo
	https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
"

ascs="
	https://packages.microsoft.com/keys/microsoft.asc
	https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
"

# remove akmod-nvidia and xorg-x11-drv-nvidia-cuda if not using nvidia
packages="
	akmod-nvidia
	bat
	brave-browser
	btop
	code
	dnf-plugins-core
	firefox
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
	speedtest-cli
	steam
	tldr
	virt-manager
	xclip
	xorg-x11-drv-nvidia-cuda
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
	com.discordapp.Discord
	com.github.tchx84.Flatseal
	com.spotify.Client
	md.obsidian.Obsidian
	org.onlyoffice.desktopeditors
	org.signal.Signal
"

# dnf
echo "
# custom
max_parallel_downloads=20
" >> /etc/dnf/dnf.conf

# mirrors
dnf install -y $mirrors
rpm --import $ascs
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
dnf config-manager --disable google-chrome
dnf copr disable phracek/PyCharm

for repo in $repos
do
	dnf config-manager --add-repo $repo
done

dnf groupupdate -y core

# packages
dnf remove -y $remove_packages
dnf update -y --refresh
dnf install -y $packages


flatpak update -y
flatpak install -y $flatpaks
sudo -u $SUDO_USER sh -c "wget -qO- https://sh.rustup.rs | sh -s -- -y"

# Ryujinx - just download latest version and extract
(
ryujinx_folder="/home/$SUDO_USER/Downloads/ryujinx"
wget -cqO /tmp/ryujinx.tar.gz $(
	curl https://api.github.com/repos/Ryujinx/release-channel-master/releases \
	| jq -r '.[0].assets[].browser_download_url' \
	| grep -E "/ryujinx-[0-9.]*-linux_x64.tar.gz" \
)
sudo -u $SUDO_USER mkdir -p $ryujinx_folder
sudo -u $SUDO_USER tar -xzf /tmp/ryujinx.tar.gz --directory=$ryujinx_folder
rm /tmp/ryujinx.tar.gz
)&

# JetBrains toolbox
(
wget -cqO /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
tar -xzf /tmp/jetbrains-toolbox.tar.gz --directory=/tmp
sudo -u $SUDO_USER /tmp/jetbrains*/jetbrains-toolbox
rm -r /tmp/jetbrains*
)&

# fonts
(
wget -cqO /tmp/CodeNewRoman.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CodeNewRoman.zip
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
