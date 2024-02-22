#!/bin/sh

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
	spotify
	obsidian
"

# dnf
echo "
# custom
fastestmirror=True
max_parallel_downloads=20
" >> /etc/dnf/dnf.conf

# mirrors
sudo dnf install -y $mirrors
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf config-manager --disable google-chrome
sudo dnf copr disable phracek/PyCharm
sudo dnf groupupdate -y core

# packages
sudo dnf update -y --refresh
sudo dnf install -y $packages

flatpak install -y $flatpaks
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# JetBrains toolbox
wget -cO /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
tar -xzf /tmp/jetbrains-toolbox.tar.gz --directory=/tmp
/tmp/jetbrains*/jetbrains-toolbox
rm -r /tmp/jetbrains*


# zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s

cp --parents ./poshthemes/* ~/.posthemes/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
cp ./zshrc ~/.zshrc
cp ./aliases ~/.config/

chsh -s $(which zsh)

read -p "Press any key to resume ..."
