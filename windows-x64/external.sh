#!/bin/bash

set -e

FREEIMAGE_SHA=48baac1f25b2aa8396ecbf795f0fb5cfa72b055e
PINMAME_SHA=be86b9665cf9bda306d0a7ae9d6c7fdfc4679b71
SDL_SHA=b5c3eab6b447111d3c7879bb547b80fb4abd9063
SDL_IMAGE_SHA=4a762bdfb7b43dae7a8a818567847881e49bdab4
SDL_TTF_SHA=07e4d1241817f2c0f81749183fac5ec82d7bbd72
SDL_MIXER_SHA=4be37aed1a4b76df71a814fbfa8ec9983f3b5508
LIBSERUM_SHA=b0cc2a871d9d5b6395658c56c65402ae388eb78c

mkdir -p tmp/build-libs/windows-x64
mkdir -p tmp/runtime-libs/windows-x64
mkdir -p tmp/include

curl -sL https://github.com/toxieainc/freeimage/archive/${FREEIMAGE_SHA}.zip -o freeimage-${FREEIMAGE_SHA}.zip
unzip freeimage-${FREEIMAGE_SHA}.zip
cd freeimage-${FREEIMAGE_SHA}
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
cmake --build build --config Release
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

curl -sL https://github.com/libsdl-org/SDL/archive/${SDL_SHA}.zip -o SDL-${SDL_SHA}.zip
unzip SDL-${SDL_SHA}.zip
cd SDL-${SDL_SHA}
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
mkdir -p ../tmp/include/SDL3
cp -r include/SDL3/* ../tmp/include/SDL3
cd ..

curl -sL https://github.com/libsdl-org/SDL_image/archive/${SDL_IMAGE_SHA}.zip -o SDL_image-${SDL_IMAGE_SHA}.zip
unzip SDL_image-${SDL_IMAGE_SHA}.zip
cd SDL_image-${SDL_IMAGE_SHA}
external/download.sh
sed -i 's/OUTPUT_NAME "SDL3_image"/OUTPUT_NAME "SDL3_image64"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLIMAGE_SAMPLES=OFF \
   -DSDLIMAGE_DEPS_SHARED=ON \
   -DSDLIMAGE_VENDORED=ON \
   -DSDLIMAGE_AVIF=OFF \
   -DSDLIMAGE_WEBP=OFF \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_image64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_image64.dll ../tmp/runtime-libs/windows-x64
mkdir -p ../tmp/include/SDL3_image
cp -r include/SDL3_image/* ../tmp/include/SDL3_image
cd ..

curl -sL https://github.com/libsdl-org/SDL_ttf/archive/${SDL_TTF_SHA}.zip -o SDL_ttf-${SDL_TTF_SHA}.zip
unzip SDL_ttf-${SDL_TTF_SHA}.zip
cd SDL_ttf-${SDL_TTF_SHA}
external/download.sh
sed -i 's/OUTPUT_NAME SDL3_ttf/OUTPUT_NAME "SDL3_ttf64"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLTTF_SAMPLES=OFF \
   -DSDLTTF_VENDORED=ON \
   -DSDLTTF_HARFBUZZ=ON \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_ttf64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_ttf64.dll ../tmp/runtime-libs/windows-x64
mkdir -p ../tmp/include/SDL3_ttf
cp -r include/SDL3_ttf/* ../tmp/include/SDL3_ttf
cd ..

curl -sL https://github.com/libsdl-org/SDL_mixer/archive/${SDL_MIXER_SHA}.zip -o SDL_mixer-${SDL_MIXER_SHA}.zip
unzip SDL_mixer-${SDL_MIXER_SHA}.zip
cd SDL_mixer-${SDL_MIXER_SHA}
external/download.sh
sed -i 's/OUTPUT_NAME "SDL3_mixer"/OUTPUT_NAME "SDL3_mixer64"/' CMakeLists.txt
cmake \
   -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLMIXER_SAMPLES=OFF \
   -DSDLMIXER_VENDORED=ON \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_mixer64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_mixer64.dll ../tmp/runtime-libs/windows-x64
mkdir -p ../tmp/include/SDL3_mixer
cp -r include/SDL3_mixer/* ../tmp/include/SDL3_mixer
cd ..

curl -sL https://github.com/zesinger/libserum/archive/${LIBSERUM_SHA}.zip -o libserum.zip
unzip libserum.zip
cd libserum-$LIBSERUM_SHA
cmake \
   -G "Visual Studio 17 2022" \
   -DPLATFORM=win \
   -DARCH=x64 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/serum64.lib ../tmp/build-libs/windows-x64
cp build/Release/serum64.dll ../tmp/runtime-libs/windows-x64
cp src/serum.h ../tmp/include
cp src/serum-decode.h ../tmp/include
cd ..
