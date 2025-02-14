#!/bin/bash

set -e

SDL_SHA=b5c3eab6b447111d3c7879bb547b80fb4abd9063
SDL_IMAGE_SHA=4a762bdfb7b43dae7a8a818567847881e49bdab4
SDL_TTF_SHA=07e4d1241817f2c0f81749183fac5ec82d7bbd72
SDL_MIXER_SHA=4be37aed1a4b76df71a814fbfa8ec9983f3b5508
FREEIMAGE_SHA=48baac1f25b2aa8396ecbf795f0fb5cfa72b055e
PINMAME_SHA=be86b9665cf9bda306d0a7ae9d6c7fdfc4679b71
LIBDMDUTIL_SHA=c7b28ff9b26d206820f438a54c9bc89171a3ae02

mkdir -p tmp/build-libs/windows-x64
mkdir -p tmp/runtime-libs/windows-x64
mkdir -p tmp/include

curl -sL https://github.com/libsdl-org/SDL/archive/${SDL_SHA}.tar.gz -o SDL-${SDL_SHA}.tar.gz
tar xzf SDL-${SDL_SHA}.tar.gz
mv SDL-${SDL_SHA} SDL
cd SDL
sed -i 's/OUTPUT_NAME "SDL3"/OUTPUT_NAME "SDL364"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DSDL_SHARED=ON \
   -DSDL_STATIC=OFF \
   -DSDL_TEST_LIBRARY=OFF \
   -B build
cmake --build build --config Release
cp build/Release/SDL364.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL364.dll ../tmp/runtime-libs/windows-x64
cp -r include/SDL3 ../tmp/include/
cd ..

curl -sL https://github.com/libsdl-org/SDL_image/archive/${SDL_IMAGE_SHA}.tar.gz -o SDL_image-${SDL_IMAGE_SHA}.tar.gz
tar xzf SDL_image-${SDL_IMAGE_SHA}.tar.gz --exclude='*/Xcode/*'
mv SDL_image-${SDL_IMAGE_SHA} SDL_image
cd SDL_image
./external/download.sh
sed -i 's/OUTPUT_NAME "SDL3_image"/OUTPUT_NAME "SDL3_image64"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLIMAGE_SAMPLES=OFF \
   -DSDLIMAGE_DEPS_SHARED=ON \
   -DSDLIMAGE_VENDORED=ON \
   -DSDLIMAGE_AVIF=OFF \
   -DSDLIMAGE_WEBP=OFF \
   -DSDL3_DIR=../SDL/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_image64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_image64.dll ../tmp/runtime-libs/windows-x64
cp -r include/SDL3_image ../tmp/include/
cd ..

curl -sL https://github.com/libsdl-org/SDL_ttf/archive/${SDL_TTF_SHA}.tar.gz -o SDL_ttf-${SDL_TTF_SHA}.tar.gz
tar xzf SDL_ttf-${SDL_TTF_SHA}.tar.gz --exclude='*/Xcode/*'
mv SDL_ttf-${SDL_TTF_SHA} SDL_ttf
cd SDL_ttf
./external/download.sh
sed -i 's/OUTPUT_NAME SDL3_ttf/OUTPUT_NAME "SDL3_ttf64"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLTTF_SAMPLES=OFF \
   -DSDLTTF_VENDORED=ON \
   -DSDLTTF_HARFBUZZ=ON \
   -DSDL3_DIR=../SDL/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_ttf64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_ttf64.dll ../tmp/runtime-libs/windows-x64
cp -r include/SDL3_ttf ../tmp/include/
cd ..

curl -sL https://github.com/libsdl-org/SDL_mixer/archive/${SDL_MIXER_SHA}.tar.gz -o SDL_mixer-${SDL_MIXER_SHA}.tar.gz
tar xzf SDL_mixer-${SDL_MIXER_SHA}.tar.gz --exclude='*/Xcode/*'
mv SDL_mixer-${SDL_MIXER_SHA} SDL_mixer
cd SDL_mixer
./external/download.sh
sed -i 's/OUTPUT_NAME "SDL3_mixer"/OUTPUT_NAME "SDL3_mixer64"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLMIXER_SAMPLES=OFF \
   -DSDLMIXER_VENDORED=ON \
   -DSDL3_DIR=../SDL/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_mixer64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_mixer64.dll ../tmp/runtime-libs/windows-x64
cp -r include/SDL3_mixer ../tmp/include/
cd ..

curl -sL https://github.com/toxieainc/freeimage/archive/${FREEIMAGE_SHA}.tar.gz -o freeimage-${FREEIMAGE_SHA}.tar.gz
tar xzf freeimage-${FREEIMAGE_SHA}.tar.gz
mv freeimage-${FREEIMAGE_SHA} freeimage
cd freeimage
cmake \
   -G "Visual Studio 17 2022" \
   -DPLATFORM=win \
   -DARCH=x64 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/freeimage64.lib ../tmp/build-libs/windows-x64
cp build/Release/freeimage64.dll ../tmp/runtime-libs/windows-x64
cp Source/FreeImage.h ../tmp/include
cd ..

curl -sL https://github.com/vbousquet/pinmame/archive/${PINMAME_SHA}.zip -o pinmame-${PINMAME_SHA}.zip
unzip pinmame-${PINMAME_SHA}.zip
cd pinmame-${PINMAME_SHA}
cp cmake/libpinmame/CMakelists.txt .
cmake \
   -G "Visual Studio 17 2022" \
   -DPLATFORM=win \
   -DARCH=x64 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/pinmame64.lib ../tmp/build-libs/windows-x64
cp build/Release/pinmame64.dll ../tmp/runtime-libs/windows-x64
cp src/libpinmame/libpinmame.h ../tmp/include
cp src/libpinmame/pinmamedef.h ../tmp/include
cd ..

curl -sL https://github.com/vpinball/libdmdutil/archive/${LIBDMDUTIL_SHA}.tar.gz -o libdmdutil-${LIBDMDUTIL_SHA}.tar.gz
tar xzf libdmdutil-${LIBDMDUTIL_SHA}.tar.gz
mv libdmdutil-${LIBDMDUTIL_SHA} libdmdutil
cd libdmdutil
./platforms/win/x64/external.sh
cmake \
   -G "Visual Studio 17 2022" \
   -DPLATFORM=win \
   -DARCH=x64 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/dmdutil64.lib ../tmp/build-libs/windows-x64
cp build/Release/dmdutil64.dll ../tmp/runtime-libs/windows-x64
cp -r include/DMDUtil ../tmp/include/
cp build/Release/zedmd64.lib ../tmp/build-libs/windows-x64
cp build/Release/zedmd64.dll ../tmp/runtime-libs/windows-x64
cp third-party/include/ZeDMD.h ../tmp/include
cp build/Release/serum64.lib ../tmp/build-libs/windows-x64
cp build/Release/serum64.dll ../tmp/runtime-libs/windows-x64
cp third-party/include/serum.h ../tmp/include
cp third-party/include/serum-decode.h ../tmp/include
cp build/Release/libserialport64.lib ../tmp/build-libs/windows-x64
cp build/Release/libserialport64.dll ../tmp/runtime-libs/windows-x64
cp build/Release/pupdmd64.lib ../tmp/build-libs/windows-x64
cp build/Release/pupdmd64.dll ../tmp/runtime-libs/windows-x64
cp third-party/include/pupdmd.h ../tmp/include
cp build/Release/sockpp64.lib ../tmp/build-libs/windows-x64
cp build/Release/sockpp64.dll ../tmp/runtime-libs/windows-x64
cp build/Release/cargs64.lib ../tmp/build-libs/windows-x64
cp build/Release/cargs64.dll ../tmp/runtime-libs/windows-x64
cd ..
