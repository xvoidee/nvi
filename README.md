![Poster](/assets/poster.png)
# About
Minimalistic setup of Neovim. I use it to develop programs in C/C++. Key features:
* usability
* speed and small runtime
* lightweight and out-of-the-box install
* but still capable to do many useful things
# Prereqs
* supported OS: Ubuntu (tested on Ubuntu 16.04 and 18.04), MacOS
* wget
* you know how to run :q!
* tinfo5 library
# Install
```
$ cd ~/Downloads
$ git clone --recursive https://github.com/xvoidee/nvi.git
$ cd nvi
$ ./install_linux-x64.sh (or ./install_darwin.sh)
```
Installer will download and extract all required dependencies. Installation will be portable, means PATH variable is not altered. After installation start nvi via:
```
~/Downloads/nvi/bin/nvi
```
Or add path to nvi executable into your PATH enrivonment (below is an example only):
```
export PATH=$PATH:~/Downloads/nvi/bin
```
# How to use
## C++
To build any C/C++ project 2 files are needed
* compilation database compile_commands.json
Example below shows how to generate database using cmake:
```
$ cd project
$ mkdir build
$ cd build
$ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
$ cd ..
$ ln -s build/compile_commands.json ./
```
Add coc-config.json to the project (make symlink to template to share between projects or create your own file):
```
$ mkdir config
$ cd config
$ ln -s /path/to/nvi/config/coc-settings.json ./
```
### clangd setup
To get clangd indexer - open any .cpp file in nvi and run these commands:
```
:CocInstall coc-clangd
:CocCommand clangd.install
```
Download takes time and once it finished clangd process will start and index your project.
## Hotkeys
nvi is equipped with basic (because plugins provide huuuge amount of functionality) set of predefined hotkeys:
Key         | Alternate | Action                                       | Editor mode
------------|-----------|----------------------------------------------|-------------
Ctrl-T      |           | Toggle file-explorer on/off                  | NORMAL
Ctrl-J      |           | Jump to split to the left                    | NORMAL
Ctrl-L      |           | Jump to split to the right                   | NORMAL
Ctrl-I      |           | Jump to split to the up                      | NORMAL
Ctrl-K      |           | Jump to split to the down                    | NORMAL
F2          |           | Save contents of the buffer (equals to :w)   | NORMAL
F3          |           | Jump to definition                           | NORMAL
F4          |           | Jump to implementation                       | NORMAL
F5          |           | Find all references                          | NORMAL
F7          |           | Open the fuzzy search [1]                    | NORMAL
F8          |           | Close the buffer only if changes are saved   | NORMAL
F10         |           | Skip all changes and close the editor        | NORMAL
F12         |           | Save all changes and close the editor        | NORMAL
Shift-Left  | ,         | To the previous buffer [2]                   | NORMAL
Shift-Right | .         | To the next buffer [2]                       | NORMAL
Ctrl-Space  |           | Open the drop-down list with suggestions [3] | INSERT

Remarks:
1. May ask to download fzf executable - agree by pressing "y"

2. Will not change buffer if unsaved

3. May conflict with language switch

# Throubleshooting
## I use command line (no X11) and colors are like from 1990s
Unfortunately tty has 8-colors palette and it is not possible to use whole set of colors. Available solutions are: use fbterm, connect to machine using PuTTy/KiTTy, connect to machine using any X11 terminal (gnome terminal, terminator, etc), use headless mode of nvi and connect gui client to it.
## I use PuTTy and modifier keys (shift/ctrl/etc) are not working
Use KiTTy.
## I use PuTTy/KiTTy and home/end keys are not working
Change terminal type to linux under Connection/Data menu in session setup (field Terminal-type string).
## I use command line (no X11) and fuzzy search (fzf) crashing
This is know issue and no fix/workaround at the moment.
## I am MacOS user and my colors are messed up in terminal
Use another terminal with 256-color support, iterm2 is one of possible alternatives...
## I installed nvi and do not see fancy characters in tabline/statusline
Install Gohu font from https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Gohu. Version uni-11 would fit with size set to 12 in your terminal. Then enable nerd fonts in config/.user.nvi.vimrc by setting g:nvi_nerd_fonts to 1.
