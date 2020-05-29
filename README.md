![Poster](/assets/poster.png)
# Prereqs
* Ubuntu (tested on Ubuntu 16.04 and 18.04)
* required packages: python3, python3-pip
* :q! - this does not scare you
# Install
## Clone
```
git clone https://github.com/xvoidee/nvimclipse.git
cd nvimclipse
git submodule init
git submodule update
```
## Install dependencies
```
sudo apt-get install python3-pip
pip3 install neovim
```
## Install nvimclipse
```
./install.sh --install-path=/home/yourname/programs
```
Script will download nodejs (~14.7Mb) and nvim (~10.5Mb) and proceed with install.
## Finish installation
Log out or source ~/.bashrc to use newly added alias "nv" (short of nvimclipse).
# Use
## C++
Typical build of any project with cmake is:
```
cd project
mkdir build
cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make
cd ..
ln -s build/compile_commands.json ./
```
Simply saying LSP backend (ccls) and intellisense (coc.nvim) need only up-to-date compile database: compile_commands.json file. The easiest way to get it - generate by cmake. For other tools (gnu make for example) more complex tooling is needed (like bear transforming Makefile to compile_commands.json). Start "nv" from same directory where compilation database is located and once any source file is opened - indexer will start over the whole sources which relate to this build.
# Throubleshooting
This section comes before first steps as most probably you will run into minor issues.
#### I cannot quit from nvimclipse with F10 key!
Disable menu (F10) accelerator key in preferences for your gnome-terminal
#### Bold fonts are messing color experience
Disable bold fonts in your terminal. If not possible (under Ubuntu 18.04), use another terminal, like terminator
# Thanks to these plugins used in nvimclipse
* Highly configurable status line: https://github.com/itchyny/lightline.vim
* Git extensions: https://github.com/tpope/vim-fugitive
* Tree file-explorer: https://github.com/scrooloose/nerdtree
* Start-up page: https://github.com/mhinz/vim-startify
* Git status for active buffer: https://github.com/airblade/vim-gitgutter
* Fuzzy search: https://github.com/junegunn/fzf and https://github.com/junegunn/fzf.vim
* Plugin manager: https://github.com/junegunn/vim-plug
* Intellisense engine with LSP support: https://github.com/neoclide/coc.nvim
* Semantic highlight for C++: https://github.com/jackguo380/vim-lsp-cxx-highlight
* Fancy icons: https://github.com/ryanoasis/vim-devicons
* Fancy buffers-bar: https://github.com/mengelbrecht/lightline-bufferline
* Light and eye-friendly color scheme: https://github.com/ayu-theme/ayu-vim
* Lightweight color schene: https://github.com/lifepillar/vim-solarized8
# Not vim plugins, but deserve personal thanksgiving
* Patched monospaced fonts (with fancy icons) for programmers: https://github.com/ryanoasis/nerd-fonts
* Language server for C++: https://github.com/MaskRay/ccls/wiki/Build
