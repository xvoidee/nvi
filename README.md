# Prereqs
* basic knowledge of Linux
* basic knowledge of Vi/Vim/Neovim (if you do not know how to quit, stop reading :))
* required packages: python3, python3-pip, zlib1g-dev, libtinfo-dev, curl
* G++7 or G++8
* custom patched NerdFont for fancy icons

# Install
## Install dependencies
```
sudo apt-get install python3-pip zlib1g-dev libtinfo-dev curl
pip3 install neovim
```

## g++7/g++8 (only for Ubuntu 14.04/16.04 users)
```
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install g++-8
```

## Install nvimclipse
```
./install.sh --install-path=/home/yourname/programs
```
Script will download clang+cmake+nodejs+nvim, total size is roughly 16MB. **'~' in --install-path is not supported!**

# Throubleshooting
This section comes before first steps as most probably you will run into minor issues.

## It is stuck during install with various wget-like output.
Sometimes it happens at the end, kill it, install complete

## Immediately after startup red line appears at bottom: "client coc abnormal exit with: 1"
Intellisense plugin coc was not installed, build it from source:
:call coc#util#build()

## I cannot quit from nvimclipse with F10 key! (default mapping)
Disable menu (F10) accelerator key in preferences for your gnome-terminal

## In Ubuntu 18.04 fancy font from NerdFonts repository is not available for select, and all special characters (folders/icons/tab separators/etc) are messed up in terminal!
Font selection in Ubuntu 18.04 changed, you need to set it up in a following way:
```
sudo apt install gnome-tweak-tool
gnome-tweaks
```
Select section "Font" on left pane and then select your monospace font on the right side.

## Highlight is not enough high-quality due to bold fonts.
Disable bold fonts in your terminal. If not possible (under Ubuntu 18.04), use another terminal, like terminator

