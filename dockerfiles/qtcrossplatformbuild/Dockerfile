# Stage 1: Build Stage for MXE
FROM imanbakhtiari/mxe:v1 AS builder

# Set the working directory and copy your Qt project files into the container
WORKDIR /app
COPY . .

# Build the project for Linux
RUN qmake server.pro && make VERBOSE=1

# Create a release directory and copy the built application
# This assumes that the built application is named 'myapp'
#RUN mkdir -p ./release && cp ./myapp ./release/

# Copy required DLLs from MXE environment to the release directory
RUN cp /mxe/usr/x86_64-w64-mingw32.shared.posix/bin/*.dll ./release/

# Copy Qt DLLs (Qt5Core, Qt5Network, Qt5WebSockets, etc.)
RUN cp /mxe/usr/x86_64-w64-mingw32.shared.posix/qt5/bin/*.dll ./release/

# Stage 2: Build Stage for the C++ project
FROM imanbakhtiari/qt:5.12 AS qt_builder

# Set the working directory
WORKDIR /app

# Copy the C++ source code and project file from the builder stage
COPY --from=builder /app/release /app/release
#COPY server.cpp /app/server.cpp
#COPY server.pro /app/
COPY . .
# Run qmake and make to build the C++ project
RUN qmake && make

# Expose the port the app will run on
EXPOSE 12345

# Set the entry point for the final application
ENTRYPOINT ["./app"]

