#!/bin/bash

if [ $EUID != 0 ]; then
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
    stow
    tldr
    virt-manager
    xclip
    zoxide
    zsh
"

read -rp "Do you want to install NVIDIA-drivers [Y/n]: " yn
if [ "$yn" == "${yn#[Nn]}" ]; then
    packages=$packages"
        akmod-nvidia
        xorg-x11-drv-nvidia-cuda
    "
fi

read -rp "Do you want to install texlive-scheme-full [y/N]: " yn
if [ "$yn" != "${yn#[Yy]}" ]; then
    packages=$packages"
        texlive-scheme-full
    "
fi

remove_packages="
    akregator
    cheese
    dragon
    gnome-boxes
    gnome-contacts
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
    org.signal.Signal
"

read -rp "Do you want to install OnlyOffice [y/N]: " yn
if [ "$yn" != "${yn#[Yy]}" ]; then
    flatpaks=$flatpaks"
        org.onlyoffice.desktopeditors
    "
fi

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

# dotfiles
(
echo "Downloading: dotfiles"
git clone --depth 1 https://github.com/BioGustav/dotfiles /home/$SUDO_USER/dotfiles
sudo -u $SUDO_USER stow /home/$SUDO_USER/dotfiles
)&

# oh-my-posh
(
curl -s https://ohmyposh.dev/install.sh | bash -s
)&

wait

echo "Setting up zsh as standard shell"
chsh -s $(which zsh) $SUDO_USER

read -p "Press any key to resume ..."
