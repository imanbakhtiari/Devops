# Path to MXE
MXE_PATH := /path/to/mxe

# Cross-compiler toolchain (for Windows 32-bit)
CC := $(MXE_PATH)/usr/bin/i686-w64-mingw32.static-g++

# Source files
SRC := main.cpp

# Output binary
OUT := myapp.exe

# Build target
all:
    $(CC) -o $(OUT) $(SRC)

clean:
    rm -f $(OUT)

