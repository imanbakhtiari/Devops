1- Clone the MXE repository:
```bash
git clone https://github.com/mxe/mxe.git
cd mxe
```

2- Install MXE dependencies:
```bash
sudo apt-get install autoconf automake autopoint bash bison bzip2 flex gettext git g++ gperf intltool libffi-dev libgdk-pixbuf2.0-dev libltdl-dev libtool libssl-dev libxml-parser-perl lzip make openssl p7zip-full patch perl pkg-config python-is-python3 ruby scons sed unzip wget xz-utils
```

```
make gtk3 -j 8 MXE_TARGETS='x86_64-w64-mingw32.static'
```


##### Assuming you have a simple C++ file 'main.cpp'
```bash
x86_64-w64-mingw32.static-g++ -o app.exe main.cpp
```


## Supported Platforms
- Windows: MXE uses MinGW toolchains (i686-w64-mingw32 for 32-bit and x86_64-w64-mingw32 for 64-bit).
- Linux: You can compile natively on Linux without MXE.
- macOS: You can use MXE in combination with other cross-compilers to build macOS binaries on Linux.

