TEMPLATE = app
TARGET = app
CONFIG += console
CONFIG -= app_bundle
CONFIG += c++11


#QMAKE_CXX = /usr/bin/x86_64-w64-mingw32-g++
#QMAKE_CC = /usr/bin/x86_64-w64-mingw32-gcc
#QMAKE_LINK = /usr/bin/x86_64-w64-mingw32-g++

# Specify the source files
SOURCES += server.cpp

# Specify the header files (if any)
HEADERS +=

# Include the necessary Qt modules
QT += core gui websockets

# Specify the necessary libraries
#LIBS += -lQt5Core -lQt5Gui -lQt5WebSockets -L/mxe/usr/lib -lGL
#LIBS += -lQt5Core -lQt5Gui -lQt5WebSockets -L/mxe/usr/lib -lopengl32

win32: LIBS += -lQt5Core -lQt5Gui -lQt5WebSockets -L/mxe/usr/lib -lopengl32
else: linux: LIBS += -lQt5Core -lQt5Gui -lQt5WebSockets -lGL

# Include paths (optional, only if additional include paths are needed)
INCLUDEPATH += /usr/include/x86_64-linux-gnu/qt5

