#!/bin/bash

# Install yaml-cpp (0.5.3 requires boost, 0.6+ requires C++11, used by OpenColorIO)
YAMLCPP_VERSION=0.5.3
if [[ ! "$GCC_VERSION" =~ ^4\. ]]; then
    YAMLCPP_VERSION=0.6.2 # 0.6.0 is the first version to require C++11
fi
YAMLCPP_VERSION_SHORT=${YAMLCPP_VERSION%.*}
YAMLCPP_TAR="yaml-cpp-${YAMLCPP_VERSION}.tar.gz"
if build_step && { force_build || { [ ! -s "$SDK_HOME/lib/pkgconfig/yaml-cpp.pc" ] || [ "$(pkg-config --modversion yaml-cpp)" != "$YAMLCPP_VERSION" ]; }; }; then
    start_build
    download_github jbeder yaml-cpp "${YAMLCPP_VERSION}" yaml-cpp- "${YAMLCPP_TAR}"
    untar "$SRC_PATH/$YAMLCPP_TAR"
    pushd "yaml-cpp-yaml-cpp-${YAMLCPP_VERSION}"
    mkdir build
    pushd build
    cmake .. -DCMAKE_INSTALL_PREFIX="$SDK_HOME" -DCMAKE_C_FLAGS="$BF" -DCMAKE_CXX_FLAGS="$BF"  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE"
    make -j${MKJOBS}
    make install
    popd
    popd
    rm -rf "yaml-cpp-yaml-cpp-${YAMLCPP_VERSION}"
    end_build
fi
