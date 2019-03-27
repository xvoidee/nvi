1. Install neovim (v.0.4.0)

Download and extract neovim for your platform.

```
wget -c https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar -zxf nvim-linux64.tar.gz
```

Check that executable nvim in nvim-linux64/bin is visible from your $PATH variable. In my case:

```
xvoidee$ cat ~/.profile | grep nvim
export PATH=$PATH:/opt/nvim-linux64/bin
```

2. Install clang (7.0.1)

Download and extract clang for your platform.

```
wget -c http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
xz --decompress clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz 
tar -xf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar
```

Check that clang is visible from your $PATH variable. In my case:

```
xvoidee$ cat ~/.profile | grep clang
export PATH=$PATH:/opt/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin
```

3. Install nodejs (10.15.3)

```
wget -c https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.xz
xz --decompress node-v10.15.3-linux-x64.tar.xz 
tar -xf node-v10.15.3-linux-x64.tar 
```
Check that nodejs is visible from your $PATH variable. In my case:

```
xvoidee$ cat ~/.profile | grep node
export PATH=$PATH:/opt/node-v10.15.3-linux-x64/bin
```
4. Install yarn

```
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
```

Reboot PC.

5. Finalize coc.nvim setup

Start nvim and execute from command mode:

```
:call coc#util#build()
```

6. Build ccls

Prereqs:
cmake version 3.8+
g++ version 7.2+ (C++17 support)

```
git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04
cmake --build Release
mkdir /opt/ccls
cp Release/ccls /opt/ccls/
```

Check that your ccls binary is accessible via $PATH.

```
xvoidee$ cat ~/.profile | grep ccls
export PATH=$PATH:/opt/ccls
```

7. Create alias for neovim

```
xvoidee$ alias | grep nvim
alias nv='nvim -u ~/.nvimclipse/init.vim'
```
8. Export project to language server index

Assumption: CMake used as build system. In this case (and many others) steps will be:

```
cd your_project
mkdir build
cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
cd ..
ln -s build/compile_commands.json ./
```

Open neovim via nv (step 7) and start editing C++ files. Plugins will scan whole project using compile database and put sources into index..
