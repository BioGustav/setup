#!/bin/sh

if (( $EUID != 0 )); then
  echo "Please run as root"
  exit 1
else
  echo "I am ROOOOOT"
fi

mirrors="
	fedora-workstation-repositories
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
"

packages="
	micro
	btop
	discord
	java-latest-openjdk
	code
	zsh
	xclip
	tldr
	gh
"
#	texlive-scheme-full

flatpaks="
	com.spotify.Client
	md.obsidian.Obsidian
"

# dnf
echo "
# custom
fastestmirror=True
max_parallel_downloads=20
" >> /etc/dnf/dnf.conf

# mirrors
dnf install -y $mirrors
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
dnf config-manager --disable google-chrome
dnf copr disable phracek/PyCharm
dnf groupupdate -y core

# packages
dnf update -y --refresh
dnf install -y $packages

flatpak update
flatpak install -y $flatpaks
sh -c "$(wget https://sh.rustup.rs -O -)" -- -y

# JetBrains toolbox
wget -cO /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
tar -xzf /tmp/jetbrains-toolbox.tar.gz --directory=/tmp
/tmp/jetbrains*/jetbrains-toolbox
rm -r /tmp/jetbrains*

# fonts
wget -cO /tmp/CodeNewRoman.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CodeNewRoman.zip
unzip /tmp/CodeNewRoman.zip -x README.md license.txt -d ~/.local/share/fonts
rm -r /tmp/CodeNewRoman*

# zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" -- --unattended

cp ./poshthemes/* ~/.poshthemes/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
cp ./zshrc ~/.zshrc
cp ./aliases ~/.config/

curl -s https://ohmyposh.dev/install.sh | bash -s

chsh -s $(which zsh)

read -p "Press any key to resume ..."
