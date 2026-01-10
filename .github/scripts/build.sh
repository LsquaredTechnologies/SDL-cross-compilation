#!/usr/bin/env bash
set -euo pipefail

PLATFORM_NAME="$1"      # e.g. linux-x64, linux-arm64, win-x64
INSTALL_PREFIX="$2"     # e.g. install/linux-x64
BUILD_TYPE="$3"         # e.g. Release
CMAKE_FLAGS="$4"        # extra flags from matrix

PREFIX=""

if [[ "$PLATFORM_NAME" == "wasm32" ]]; then
    export EMSDK=/emsdk
    source /emsdk/emsdk_env.sh
    PREFIX="emcmake"
    CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_TOOLCHAIN_FILE=/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"
fi

echo "=============================================="
echo " Building SDL3"
echo " Platform : $PLATFORM_NAME"
echo " Install  : $INSTALL_PREFIX"
echo " Type     : $BUILD_TYPE"
echo " Flags    : $CMAKE_FLAGS"
echo "=============================================="

$PREFIX cmake -S SDL -B "build-$PLATFORM_NAME" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DSDL_SHARED=ON -DSDL_STATIC=ON \
    -DSDL_TESTS=OFF -DSDL_INSTALL_TESTS=OFF \
    -DSDL_DISABLE_INSTALL=OFF \
    $CMAKE_FLAGS

cmake --build "build-$PLATFORM_NAME" --config "$BUILD_TYPE" --parallel
ls "build-$PLATFORM_NAME"

cmake --install "build-$PLATFORM_NAME" --config "$BUILD_TYPE"
