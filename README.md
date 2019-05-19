1. Prereqs

* basic knowledge of Linux
* basic knowledge of Vi/Vim/Neovim (at least how to quit)
* required packages: python3, python3-pip, zlib1g-dev, libtinfo-dev, curl
* G++-8 to build language server (G++-7 will work as well)
* custom patched NerdFont for fancy icons

2. Install

Install dependencies

```
sudo apt-get install python3-pip zlib1g-dev libtinfo-dev curl
sudo pip3 install neovim
```

Install G++-7 or G++-8 if you do not have it from any repository.

```
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install g++-8
```

Install nvimclipse. It will download clang+cmake+nodejs+nvim, total size is 416MB.
For example:

```
./install.sh --install-path=/home/yourname/programs
```

'~' in --install-path is not supported!

3. Throubleshooting.

Q: It is stuck during install with various wget-like output.
A: Sometimes it happens at the end, execute: killall -9 neovim

Q: Immediately after startup red line appears at bottom: "client coc abnormal exit with: 1"
A: Intellisense plugin coc was not installed, build it from source:
:call coc#util#build()



