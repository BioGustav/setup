#!/bin/sh

if (( $EUID != 0 )); then
  echo "Please run as root"
  exit 1
else
  echo "Running as root"
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
	bat
	brave-browser
	btop
	code
	dnf-plugins-core
	evince
 	eza
	fastfetch
	firefox
	gcc
	gh
	git
	java-latest-openjdk
	kate
	mangohud
	micro
	mupdf
	mpv
 	neovim
	obs-studio
	pdfarranger
 	ripgrep
	speedtest-cli
	steam
	tldr
	virt-manager
	xclip
	z
 	zsh
	akmod-nvidia
	xorg-x11-drv-nvidia-cuda
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
	net.davidotek.pupgui2
	org.mozilla.Thunderbird
	org.onlyoffice.desktopeditors
	org.signal.Signal
"

# fonts: https://www.nerdfonts.com/font-downloads
fonts="
	CodeNewRoman
	RobotoMono
"

echo
echo "Setting up dnf!"
# dnf
echo "
# custom
max_parallel_downloads=20
" >> /etc/dnf/dnf.conf

echo
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
echo
echo "Setting up: rpm packages"
dnf remove -y $remove_packages
dnf update -y --refresh
dnf install -y $packages

echo
echo "Setting up: flatpak packages"
flatpak update -y
flatpak install -y $flatpaks

echo
echo "Setting up: rust-lang"
sudo -u $SUDO_USER sh -c "wget -qO- https://sh.rustup.rs | sh -s -- -y"

echo
# Ryujinx - just download latest version and extract
(
ryujinx_folder="/home/$SUDO_USER/Downloads/ryujinx"
echo "Downloading: Ryujinx"
wget -cqO /tmp/ryujinx.tar.gz $(
	curl -s https://api.github.com/repos/Ryujinx/release-channel-master/releases \
	| jq -r '.[0].assets[].browser_download_url' \
	| grep -E "/ryujinx-[0-9.]*-linux_x64.tar.gz"
)
sudo -u $SUDO_USER mkdir -p $ryujinx_folder
echo "Unpacking Ryujinx to: $ryujinx_folder"
sudo -u $SUDO_USER tar -xzf /tmp/ryujinx.tar.gz --directory=$ryujinx_folder
rm /tmp/ryujinx.tar.gz
)&

# JetBrains toolbox
(
echo "Downloading: jetbrains-toolbox"
wget -cqO /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
echo "Extracting: jetbrains-toolbox"
tar -xzf /tmp/jetbrains-toolbox.tar.gz --directory=/tmp
echo "Running: jetbrains-toolbox"
sudo -u $SUDO_USER /tmp/jetbrains*/jetbrains-toolbox
rm -r /tmp/jetbrains*
)&

# fonts
font_folder="/home/$SUDO_USER/.local/share/fonts/"
for font in $fonts
do
	(
	echo "Downloading: $font (font)"
	wget -cqO /tmp/$font.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip
	sudo -u $SUDO_USER mkdir -p $font_folder/$font
	echo "Unpacking: $font (font)"
	unzip -Cq /tmp/$font.zip -x readme* license* -d $font_folder/$font
	rm -r /tmp/$font*
	)&
done


wait

# zsh
echo "Installing: oh-my-zsh"
sudo -u $SUDO_USER sh -c "wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended"
echo "Installing: oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s
curl -sL git.io/antigen > /usr/local/bin/antigen.zsh &
cp -r ./themes /home/$SUDO_USER/.config/ &
cp ./zshrc /home/$SUDO_USER/.zshrc &
cp ./aliases /home/$SUDO_USER/.config/ &

wait 
echo "Setting up zsh as standard shell"
chsh -s $(which zsh) $SUDO_USER

read -p "Press any key to resume ..."
