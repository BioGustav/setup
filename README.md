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
Before running a script from any source, **read** it through and be sure it does not do anything bad!

Now that that's said, let's continue.\
Run this command in your terminal to download and run the script:
```
curl -sL https://raw.githubusercontent.com/BioGustav/main/setup.sh | sudo sh
```

## Installed packages
Optional packages have checkboxes (marked &rarr; default=yes)
### DNF:
* bat
* brave-browser
* btop
* code
* dnf-plugins-core
* evince
* eza
* fastfetch
* firefox
* gcc
* gh
* git
* java-latest-openjdk
* kate
* mangohud
* micro
* mupdf
* mpv
* neovim
* obs-studio
* pdfarranger
* ripgrep
* speedtest-cli
* steam
* tldr
* virt-manager
* xclip
* z
* zsh

* [x] akmod-nvidia
* [x] xorg-x11-drv-nvidia-cuda
* [ ] texlive-scheme-full

### Flatpak
* Bitwarden
* Discord
* Flatseal
* Spotify
* Obsidian
* ProtonUpGUI
* Thunderbird
* Signal

### Other
* Jetbrains Toolbox - (official "installer")
* RustUp - (official install script)

### Removed

### Downloaded only
These packages/binaries/scripts are only downloaded, but **not** installed/run.
* Ryujinx
* CodeNewRoman Nerd Font
* RobotoMono Nerd Font

## Alias

## Configurations
