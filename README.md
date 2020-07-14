![Poster](/assets/poster.png)
# Prereqs
* Supported OS: Ubuntu (tested on Ubuntu 16.04 and 18.04), MacOS
* :q! - this does not scare you
* wget available in $PATH (used to download nodejs and neovim binaries)
# About
Minimalistic setup of Neovim which I use to develop prograims in C/C++. Focus is on:
* usability
* speed and small runtime
* lightweight and out-of-the-box install
* but still try to keep it feature-rich

Supports only C/C++ at the moment. Other languages/plugins will be added in future.
# Install
Installer is bundled with precompiled ccls language server, other dependencies will be downloaded from the internet (nodejs and neovim).
```
$ cd ~/Downloads
$ git clone --recursive https://github.com/xvoidee/nvi.git
$ cd nvi
$ ./install_linux-x64.sh (or ./install_darwin.sh)
```
Optional: add you nvi folder to your PATH variable (to directly call nvi executable script). Otherwise execute by running ~/Downloads/nvi/bin/nvi (assume that you have cloned repository to your Downloads folder)
# How to use
## C++
To build any C/C++ project 2 files are needed: compilation database (compile_commands.json) and hints for indexer (.ccls).
Compilation database can be obtained from cmake:
```
$ cd project
$ mkdir build
$ cd build
$ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
$ cd ..
$ ln -s build/compile_commands.json ./
```
Final step is to teach indexer how to find default headers (like stddef). Pathes to these headers are not being exported into compilation database. So you need to obtain list of these directories by your own and put them into special hints file named .ccls:
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
Or by calling generate_ccls_PLATFORM.sh from scripts subfolder from nvi distribution. Contents of .ccls file should be similar to (actual pathes may differ depending on your OS/Compiler):
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
Now start nvi, ccd to your project directory and open any source file. In process monitor you will see new entry ccls (amount of threads will match amount of your CPUs). For few minutes it will run on 100% load and index sources into folder named .ccls-cache.
## Hotkeys
nvi is equipped with basic (because plugins provide huuuge amount of functionality) set of predefined hotkeys:
Key | Action | Editor mode | Comments
----| ------ | ----------- | --------
Ctrl-T|Toggle NERDTree (file-explorer) on/off|NORMAL|
Ctrl-J|Jump to split one more left|NORMAL|
Ctrl-L|Jump to split one more right|NORMAL|
Ctrl-I|Jump to split one more up|NORMAL|
Ctrl-K|Jump to split one more down|NORMAL|
F2|Save contents of buffer (equals to :w)|NORMAL|
F3|Jump to definition|NORMAL|
F4|Jump to implementation|NORMAL|
F5|Find all references|NORMAL|
F7|Open fuzzy search by filename|NORMAL|May ask to download fzf executable - agree by pressing "y"
F8|Close buffer only if changes are saved|NORMAL|
F10|Skip all changes and close editor|NORMAL|
F12|Save all changes and close editor|NORMAL|
Shift-Left|Open previous buffer only if changes are saved|NORMAL|
Shift-Right|Open next buffer only if changes are saved|NORMAL|
Ctrl-Space|Auto-complete, opens drop-down list with suggestions|INSERT|May conflict with language switch
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
