![Poster](/screenshots/poster.png)

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

#### It is stuck during install with various wget-like output.
Sometimes it happens at the end, kill it, install complete

#### "client coc abnormal exit with: 1" after startup in status line
Intellisense plugin coc was not installed, build it from source:
:call coc#util#build()

#### I cannot quit from nvimclipse with F10 key!
Disable menu (F10) accelerator key in preferences for your gnome-terminal

#### Weird characters are displayed everywhere
NerdFont is not setFont selection in Ubuntu 18.04 changed, you need to set it up in a following way:
```
sudo apt install gnome-tweak-tool
gnome-tweaks
```
Select section "Font" on left pane and then select your monospace font on the right side.

#### Bold fonts are messing color experience
Disable bold fonts in your terminal. If not possible (under Ubuntu 18.04), use another terminal, like terminator

# Thanks to these plugins used in nvimclipse

* Light and eye-friendly color scheme: https://github.com/ayu-theme/ayu-vim
* Highly configurable status line: https://github.com/itchyny/lightline.vim
* Git extensions: https://github.com/tpope/vim-fugitive
* Tree file-explorer: https://github.com/scrooloose/nerdtree
* Start-up page: https://github.com/mhinz/vim-startify
* Git status for active buffer: https://github.com/airblade/vim-gitgutter
* Fuzzy search: https://github.com/junegunn/fzf and https://github.com/junegunn/fzf.vim
* Plugin manager: https://github.com/junegunn/vim-plug
* Intellisense engine with LSP support: https://github.com/neoclide/coc.nvim
* Semantic highlight for C++: https://github.com/arakashic/chromatica.nvim
* Fancy icons: https://github.com/ryanoasis/vim-devicons
* Fancy buffers-bar: https://github.com/mengelbrecht/lightline-bufferline

# Not vim plugins, but deserve personal thanksgiving

* Patched monospaced fonts (with fancy icons) for programmers: https://github.com/ryanoasis/nerd-fonts
* Language server for C++: https://github.com/MaskRay/ccls/wiki/Build

