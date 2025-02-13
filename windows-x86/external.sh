#!/bin/bash

set -e

SDL_SHA=b5c3eab6b447111d3c7879bb547b80fb4abd9063
SDL_IMAGE_SHA=4a762bdfb7b43dae7a8a818567847881e49bdab4
SDL_TTF_SHA=07e4d1241817f2c0f81749183fac5ec82d7bbd72
SDL_MIXER_SHA=4be37aed1a4b76df71a814fbfa8ec9983f3b5508
FREEIMAGE_SHA=48baac1f25b2aa8396ecbf795f0fb5cfa72b055e
PINMAME_SHA=be86b9665cf9bda306d0a7ae9d6c7fdfc4679b71
LIBDMDUTIL_SHA=c7b28ff9b26d206820f438a54c9bc89171a3ae02

mkdir -p tmp/build-libs/windows-x86
mkdir -p tmp/runtime-libs/windows-x86
mkdir -p tmp/include

curl -sL https://github.com/libsdl-org/SDL/archive/${SDL_SHA}.tar.gz -o SDL-${SDL_SHA}.tar.gz
tar xzf SDL-${SDL_SHA}.tar.gz
mv SDL-${SDL_SHA} SDL
cd SDL
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DSDL_SHARED=ON \
   -DSDL_STATIC=OFF \
   -DSDL_TEST_LIBRARY=OFF \
   -B build
cmake --build build --config Release
cp build/Release/SDL3.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3.dll ../tmp/runtime-libs/windows-x86
cp -r include/SDL3 ../tmp/include/
cd ..

curl -sL https://github.com/libsdl-org/SDL_image/archive/${SDL_IMAGE_SHA}.tar.gz -o SDL_image-${SDL_IMAGE_SHA}.tar.gz
tar xzf SDL_image-${SDL_IMAGE_SHA}.tar.gz --exclude='*/Xcode/*'
mv SDL_image-${SDL_IMAGE_SHA} SDL_image
cd SDL_image
./external/download.sh
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLIMAGE_SAMPLES=OFF \
   -DSDLIMAGE_DEPS_SHARED=ON \
   -DSDLIMAGE_VENDORED=ON \
   -DSDLIMAGE_AVIF=OFF \
   -DSDLIMAGE_WEBP=OFF \
   -DSDL3_DIR=../SDL/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_image.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3_image.dll ../tmp/runtime-libs/windows-x86
cp -r include/SDL3_image ../tmp/include/
cd ..

curl -sL https://github.com/libsdl-org/SDL_ttf/archive/${SDL_TTF_SHA}.tar.gz -o SDL_ttf-${SDL_TTF_SHA}.tar.gz
tar xzf SDL_ttf-${SDL_TTF_SHA}.tar.gz --exclude='*/Xcode/*'
mv SDL_ttf-${SDL_TTF_SHA} SDL_ttf
cd SDL_ttf
./external/download.sh
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLTTF_SAMPLES=OFF \
   -DSDLTTF_VENDORED=ON \
   -DSDLTTF_HARFBUZZ=ON \
   -DSDL3_DIR=../SDL/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_ttf.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3_ttf.dll ../tmp/runtime-libs/windows-x86
cp -r include/SDL3_ttf ../tmp/include/
cd ..

curl -sL https://github.com/libsdl-org/SDL_mixer/archive/${SDL_MIXER_SHA}.tar.gz -o SDL_mixer-${SDL_MIXER_SHA}.tar.gz
tar xzf SDL_mixer-${SDL_MIXER_SHA}.tar.gz --exclude='*/Xcode/*'
mv SDL_mixer-${SDL_MIXER_SHA} SDL_mixer
cd SDL_mixer
./external/download.sh
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLMIXER_SAMPLES=OFF \
   -DSDLMIXER_VENDORED=ON \
   -DSDL3_DIR=../SDL/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_mixer.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3_mixer.dll ../tmp/runtime-libs/windows-x86
cp -r include/SDL3_mixer ../tmp/include/
cd ..

curl -sL https://github.com/toxieainc/freeimage/archive/${FREEIMAGE_SHA}.tar.gz -o freeimage-${FREEIMAGE_SHA}.tar.gz
tar xzf freeimage-${FREEIMAGE_SHA}.tar.gz
mv freeimage-${FREEIMAGE_SHA} freeimage
cd freeimage
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DPLATFORM=win \
   -DARCH=x86 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/freeimage.lib ../tmp/build-libs/windows-x86
cp build/Release/freeimage.dll ../tmp/runtime-libs/windows-x86
cp Source/FreeImage.h ../tmp/include
cd ..

curl -sL https://github.com/vbousquet/pinmame/archive/${PINMAME_SHA}.zip -o pinmame-${PINMAME_SHA}.zip
unzip pinmame-${PINMAME_SHA}.zip
cd pinmame-${PINMAME_SHA}
cp cmake/libpinmame/CMakelists.txt .
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DPLATFORM=win \
   -DARCH=x86 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/pinmame.lib ../tmp/build-libs/windows-x86
cp build/Release/pinmame.dll ../tmp/runtime-libs/windows-x86
cp src/libpinmame/libpinmame.h ../tmp/include
cp src/libpinmame/pinmamedef.h ../tmp/include
cd ..

curl -sL https://github.com/vpinball/libdmdutil/archive/${LIBDMDUTIL_SHA}.tar.gz -o libdmdutil-${LIBDMDUTIL_SHA}.tar.gz
tar xzf libdmdutil-${LIBDMDUTIL_SHA}.tar.gz
mv libdmdutil-${LIBDMDUTIL_SHA} libdmdutil
cd libdmdutil
./platforms/win/x86/external.sh
cmake \
   -G "Visual Studio 17 2022" \
   -A Win32 \
   -DPLATFORM=win \
   -DARCH=x86 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/dmdutil.lib ../tmp/build-libs/windows-x86
cp build/Release/dmdutil.dll ../tmp/runtime-libs/windows-x86
cp -r include/DMDUtil ../tmp/include/
cp build/Release/zedmd.lib ../tmp/build-libs/windows-x86
cp build/Release/zedmd.dll ../tmp/runtime-libs/windows-x86
cp third-party/include/ZeDMD.h ../tmp/include
cp build/Release/serum.lib ../tmp/build-libs/windows-x86
cp build/Release/serum.dll ../tmp/runtime-libs/windows-x86
cp third-party/include/serum.h ../tmp/include
cp third-party/include/serum-decode.h ../tmp/include
cp build/Release/libserialport.lib ../tmp/build-libs/windows-x86
cp build/Release/libserialport.dll ../tmp/runtime-libs/windows-x86
cp build/Release/pupdmd.lib ../tmp/build-libs/windows-x86
cp build/Release/pupdmd.dll ../tmp/runtime-libs/windows-x86
cp third-party/include/pupdmd.h ../tmp/include
cp build/Release/sockpp.lib ../tmp/build-libs/windows-x86
cp build/Release/sockpp.dll ../tmp/runtime-libs/windows-x86
cp build/Release/cargs.lib ../tmp/build-libs/windows-x86
cp build/Release/cargs.dll ../tmp/runtime-libs/windows-x86
cd ..