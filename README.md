# Quickstart Fedora KDE
These are scripts and files for my personal configuration of Fedora KDE.

## Versions
* Fedora 40 Workstation
* Fedora 40 KDE

This install script uses 
[dnf](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/package-management/DNF/),
[rpm](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/RPM/) and 
[flatpak](https://docs.flatpak.org/en/latest/index.html) to manage mirrors and packages!
Be sure to have all of them on your machine before running this install script!

I **CANNOT** garantee that this script works on any other OS.
I only tested it on Fedora 40 Workstation/KDE (in a VM).

## Usage
**STOP!**\
Before running a script from any source, **read** it through and be sure it does no harm!

Now that that's said, let's continue.\
Clone the repo and run `setup.sh`.

## Installed packages
Optional packages have checkboxes. A marked box means, that by default it will be installed.
When running the script you will be asked if you want them.
### DNF
* [x] [akmod-nvidia](https://www.nvidia.com/)
* [bat](https://crates.io/crates/bat/)
* [brave-browser](https://brave.com/)
* [btop](https://github.com/aristocratos/btop/)
* [code](https://code.visualstudio.com/)
* [dnf-plugins-core](https://github.com/rpm-software-management/dnf-plugins-core/)
* [evince](https://wiki.gnome.org/Apps/Evince/)
* [eza](https://crates.io/crates/eza/)
* [fastfetch](https://github.com/fastfetch-cli/fastfetch/)
* [firefox](https://www.mozilla.org/firefox/)
* [gcc](https://gcc.gnu.org/)
* [gh](https://cli.github.com/)
* [git](https://git-scm.com/)
* [java-latest-openjdk](https://openjdk.java.net/)
* [mangohud](https://github.com/flightlessmango/MangoHud/)
* [micro](https://micro-editor.github.io/)
* [mpv](https://mpv.io/)
* [mupdf](https://mupdf.com/)
* [ncdu](https://dev.yorhel.nl/ncdu/)
* [neovim](https://neovim.io/)
* [nmap](https://nmap.org/)
* [obs-studio](https://obsproject.com/)
* [pdfarranger](https://github.com/pdfarranger/pdfarranger/)
* [ripgrep](https://crates.io/crates/ripgrep/)
* [speedtest-cli](https://github.com/sivel/speedtest-cli/)
* [steam](https://steampowered.com/)
* [stow](https://www.gnu.org/software/stow/stow.html)
* [ ] [texlive-scheme-full](http://tug.org/texlive/)
* [tldr](https://github.com/tldr-pages/tldr-python-client/)
* [virt-manager](https://virt-manager.org/)
* [xclip](http://sourceforge.net/projects/xclip/)
* [x] [xorg-x11-drv-nvidia-cuda](https://www.nvidia.com/)
* [zoxide](https://crates.io/crates/zoxide/)
* [zsh](https://www.zsh.org/)

### Flatpak
* [Bitwarden](https://bitwarden.com/)
* [Discord](https://discord.com/)
* [Flatseal](https://github.com/tchx84/Flatseal/)
* [Obsidian](https://obsidian.md/)
* [ ] [OnlyOffice](https://www.onlyoffice.com/)
* [ProtonUpGUI](https://github.com/DavidoTek/ProtonUp-Qt/)
* [Signal](https://signal.org/)
* [Spotify](https://spotify.com/)
* [Thunderbird](https://www.thunderbird.net/)

### Other
* [Jetbrains Toolbox](https://www.jetbrains.com/toolbox-app/) - (official "installer")
* [oh-my-posh](https://ohmyposh.dev/)
* [RustUp](https://rustup.rs/) - (official install script)
* [zinit](https://github.com/zdharma-continuum/zinit/)

## Removed packages
* akregator
* cheese
* dragon
* gnome-boxes
* gnome-contacts
* gnome-maps
* gnome-tour
* gnome-weather
* elisa-player
* libreoffice-*
* kaddressbook
* kamaso
* kmahjongg
* kmines
* kmail
* kpat
* kolourpaint
* konversation
* korganizer
* rhythmbox
* simple-scan
* totem
* yelp

## Downloaded only
These packages/binaries/scripts are only downloaded, but **not** installed/run.
* [CodeNewRoman Nerd Font](https://www.nerdfonts.com/font-downloads/)
* [RobotoMono Nerd Font](https://www.nerdfonts.com/font-downloads/)
* [Ryujinx](https://github.com/Ryujinx/Ryujinx/)

## Alias
basic:
* `c` - `clear`
* `cat` - `bat`
* `l` - `ls -lAh`
* `ls` - `ls --color`
* `vim` - `nvim`
* `z` - `zoxide query`

dnf:
* `s` - `dnf search`
* `i` - `sudo dnf install`
* `r` - `sudo dnf remove`
* `u` - `sudo dnf upgrade --refresh && flatpak upgrade`
* `uy` - `sudo dnf upgrade --refresh -y && flatpak upgrade -y`

copy-pasta:
* `clipboard` - `xclip -selection clipboard`
* `cclip` - `xclip -rmlastnl -selection clipboard`
* `pclip` - `xclip -out -selection clipboard`

## Configurations
All configs are cloned from the [dotfiles-repo](https://github.com/biogustav/dotfiles).
