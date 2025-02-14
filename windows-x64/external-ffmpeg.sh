#!/bin/bash

set -e

FFMPEG_SHA=b08d7969c550a804a59511c7b83f2dd8cc0499b8

mkdir -p tmp/build-libs/windows-x64
mkdir -p tmp/runtime-libs/windows-x64
mkdir -p tmp/include

curl -sL https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_SHA}.tar.gz -o FFmpeg-${FFMPEG_SHA}.tar.gz
tar xzf FFmpeg-${FFMPEG_SHA}.tar.gz
mv FFmpeg-${FFMPEG_SHA} ffmpeg
cd ffmpeg
./configure \
    --target-os=mingw32 \
    --arch="x86_64" \
    --cross-prefix="x86_64-w64-mingw32-" \
    --enable-shared \
    --disable-static \
    --disable-programs \
    --disable-doc \
    --build-suffix="64"
make -j$(nproc)
for LIB in avcodec avdevice avfilter avformat avutil swresample swscale; do
   DIR="lib${LIB}"
   cp "${DIR}/${LIB}64.lib" ../tmp/build-libs/windows-x64
   cp "${DIR}/${LIB}64.dll" ../tmp/runtime-libs/windows-x64
   mkdir -p ../tmp/include/${DIR}
   cp ${DIR}/*.h ../tmp/include/${DIR}
done
cd ..
