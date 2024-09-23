1- Clone the MXE repository:
```bash
git clone https://github.com/mxe/mxe.git
cd mxe
```

```bash
apt-get install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libgl-dev \
    libpcre3-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python3 \
    python3-distutils \
    python3-mako \
    python3-packaging \
    python3-pkg-resources \
    python-is-python3 \
    ruby \
    sed \
    sqlite3 \
    unzip \
    wget \
    xz-utils
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

