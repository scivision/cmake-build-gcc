#!/usr/bin/env bash

p=$HOME/gcc-devel
# adjust to your GCC install location

case "$OSTYPE" in
  darwin*)
    system_path=$(xcrun --sdk macosx --show-sdk-path)/usr/lib
    export LIBRARY_PATH=${system_path}
    export DYLD_LIBRARY_PATH=${p}/lib
    ;;
  linux*)
    export LD_LIBRARY_PATH=${p}/lib64:${p}/lib
    ;;
esac

export C_INCLUDE_PATH=${p}/include

export CPLUS_INCLUDE_PATH=${p}/include

export CC=${p}/bin/gcc CXX=${p}/bin/g++ FC=${p}/bin/gfortran

$FC --version
