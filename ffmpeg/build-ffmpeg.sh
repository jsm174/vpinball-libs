#!/bin/bash

set -e 

BUILD_ARCH="${BUILD_ARCH:-x86_64}"

if [ "$BUILD_ARCH" = "x86" ]; then
    CROSS_PREFIX="i686-w64-mingw32-"
    BUILD_SUFFIX=""
    ARCH_FLAG="x86"
else
    CROSS_PREFIX="x86_64-w64-mingw32-"
    BUILD_SUFFIX="64"
    ARCH_FLAG="x86_64"
fi

echo "Building FFmpeg for $BUILD_ARCH..."

./configure \
    --target-os=mingw32 \
    --arch="$ARCH_FLAG" \
    --cross-prefix="$CROSS_PREFIX" \
    --enable-shared \
    --disable-static \
    --disable-programs \
    --disable-doc \
    --build-suffix="$BUILD_SUFFIX"

make -j$(nproc)