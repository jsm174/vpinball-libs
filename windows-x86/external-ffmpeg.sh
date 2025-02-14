#!/bin/bash

set -e

FFMPEG_SHA=b08d7969c550a804a59511c7b83f2dd8cc0499b8

mkdir -p tmp/build-libs/windows-x86
mkdir -p tmp/runtime-libs/windows-x86
mkdir -p tmp/include

curl -sL https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_SHA}.tar.gz -o FFmpeg-${FFMPEG_SHA}.tar.gz
tar xzf FFmpeg-${FFMPEG_SHA}.tar.gz
mv FFmpeg-${FFMPEG_SHA} ffmpeg
cd ffmpeg
./configure \
    --target-os=mingw32 \
    --arch="x86" \
    --cross-prefix="i686-w64-mingw32-" \
    --enable-shared \
    --disable-static \
    --disable-programs \
    --disable-doc
make -j$(nproc)
for LIB in avcodec avdevice avfilter avformat avutil swresample swscale; do
   DIR="lib${LIB}"
   cp "${DIR}/${LIB}.lib" ../tmp/build-libs/windows-x86
   cp "${DIR}/${LIB}.dll" ../tmp/runtime-libs/windows-x86
   mkdir -p ../tmp/include/${DIR}
   cp ${DIR}/*.h ../tmp/include/${DIR}
done
cd ..
