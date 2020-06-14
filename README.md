![Poster](/assets/poster.png)
# Prereqs
* Ubuntu (tested on Ubuntu 16.04 and 18.04)
* :q! - this does not scare you

# Install
Installer is bundled with precompiled ccls language server, 2 other dependencies will be downloaded from internet (nodejs ~14.7Mb and neovim ~10.5Mb).
```
$ mkdir ~/Programs
$ cd ~/Downloads
$ git clone --recursive https://github.com/xvoidee/nvimclipse.git
$ cd nvimclipse
$ ./install_linux.sh --install-path=$HOME --install-alias=nv --install-alias-to=.bashrc
```
Change parameters according to your setup and environment. For example shell rc file could be .zshrc (default on MacOS).
Installation will:
* create 2 directories ~/nvimclipse (configuration files) and ~/nvimclipse_3rdparty (dependencies)
* alias "nv" to your bash shell. If you use other shell pass your rc file (.zshrc for example)
When installation is finished - log out or source ~/.bashrc (or your shell rc) to use newly added alias "nv" (short of nvimclipse).
# How to use
## C++
To build any C/C++ project 2 files are needed: compilation database (compile_commands.json) and hints for compiler (.ccls).
Compilation database can be obtained from cmake:
```
$ cd project
$ mkdir build
$ cd build
$ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
$ cd ..
$ ln -s build/compile_commands.json ./
```
Final step is to teach intellisense and indexer how to find default headers (like stddef). Pathes to these headers are not being exported into compilation database. So you need to obtain list of these directories by your own and put them into special hints file named .ccls:
### Linux
```
$ echo "%compile_commands.json" > .ccls
$ g++ -Wp,-v -x c++ - -fsyntax-only < /dev/null 2>&1 | sed -n '/#include <...>/,/End/p' | egrep -v '#include|End' | sed 's/ \//-I\//g' | sed 's/ (framework directory)//g' >> .ccls
```
### MacOS
```
$ echo "%compile_commands.json" > .ccls
$ /Library/Developer/CommandLineTools/usr/bin/c++ -Wp,-v -x c++ - -fsyntax-only < /dev/null 2>&1 | sed -n '/#include <...>/,/End/p' | egrep -v '#include|End' | sed 's/ \//-I\//g' | sed 's/ (framework directory)//g' >> .ccls
```
Contents of .ccls file should be similar to (actual pathes may differ depending on your OS/Compiler, check your project settings):
```
$ cat .ccls
%compile_commands.json
-I/usr/include/c++/5
-I/usr/include/x86_64-linux-gnu/c++/5
-I/usr/include/c++/5/backward
-I/usr/lib/gcc/x86_64-linux-gnu/5/include
-I/usr/local/include
-I/usr/lib/gcc/x86_64-linux-gnu/5/include-fixed
-I/usr/include/x86_64-linux-gnu
-I/usr/include
```
Now start nv, pickup any source file. In process monitor you will see new entry ccls (amount of threads will match amount of your CPUs). For few minutes it will run on 100% load and index sources into folder named .ccls-cache.
## Hotkeys
nvimclipse is equipped with basic (because plugins provide huuuge amount of functionality) set of predefined hotkeys:
Key | Action | Mode
----| ------ | ----
Ctrl-T|Toggle NERDTree (file-explorer) on/off|NORMAL
Ctrl-J|Jump to split one more left|NORMAL
Ctrl-L|Jump to split one more right|NORMAL
Ctrl-I|Jump to split one more up|NORMAL
Ctrl-K|Jump to split one more down|NORMAL
F2|Save contents of buffer (equals to :w)|NORMAL
F3|Jump to definition|NORMAL
F4|Jump to implementation|NORMAL
F5|Find all references|NORMAL
F7|Open fuzzy search by filename|NORMAL
F8|Close buffer only if changes are saved|NORMAL
F10|Skip all changes and close editor|NORMAL
F12|Save all changes and close editor|NORMAL
Shift-Left|Open previous buffer only if changes are saved|NORMAL
Shift-Right|Open next buffer only if changes are saved|NORMAL
Ctrl-Space|Auto-complete, opens drop-down list with suggestions|INSERT
# Throubleshooting
## I use command line (no X11) and colors are like from 1990s
Unfortunately tty has 8-colors palette and it is not possible to use whole set of colors. Available solutions are: use fbterm, connect to machine using PuTTy/KiTTy, connect to machine using any X11 terminal (gnome terminal, terminator, etc).
## I use PuTTy and modifier keys (shift/ctrl/etc) are not working
Use KiTTy.
## I use PuTTy/KiTTy and home/end keys are not working
Change terminal type to linux under Connection/Data menu in session setup (field Terminal-type string).
## I use command line (no X11) and fuzzy search (fzf) crashing
This is know issue and no fix/workaround at the moment.
## I am MacOS user and my colors are messed up in terminal
Use another terminal with 256-color support, iterm2 is one of possible alternatives..
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
