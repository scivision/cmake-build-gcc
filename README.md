# CMake build GCC

Build [GCC](https://gcc.gnu.org/install/)
natively for C, C++, Fortran languages.
Builds prerequisite libraries GMP, MPFR, and MPC from CMake.

Platforms known to work include:

* Linux (Intel/AMD CPU)
* MacOS (Apple Silicon CPU)

Numerous platforms require specific patches that we don't currently implement.
The easiest way may be to clone their GCC fork as we do for Apple Silicon.

This CMake project can be more convenient than manually downloading and configuring each project.
We assume fundamental
[prerequisites](https://gcc.gnu.org/install/prerequisites.html)
such as libc, Autotools, Make, CMake are present.
The 3-stage
[compiler bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(compilers))
is enabled to help ensure a working, performant GCC.

## Prerequsites

* CentOS: `dnf install cmake make autoconf autoconf-archive libtool`
* Ubuntu: `apt install cmake make autoconf autoconf-archive libtool`

## Options

These options are by default enabled, but may be disabled by adding the CMake configure arguments:

Set GCC version
: `-Dversion=12.2.0`

Set GCC Git tag
: `-Dgcc_tag=releases/gcc-12.2.0`

disable ISL for Graphite optimizations
: `-Disl=off`

disable C++
: `-Dcpp=off`

disable Fortran
: `-Dfortran=off`

disable Gcov coverage tool
:`-Dgcov=off`

disable link time optimization
: `-Dlto=off`

disable Zstd compression (fallback to Zlib)
: `-Dzstd=off`

## Build

This CMake project assumes the system already has Autotools, Make, and a new-enough C/C++ compiler.
GCC will take 10s of minutes to build, even on a powerful workstation.
The following commands build GCC and install it to ~/gcc-devel.
By default, a recent release of GCC is built using source from the
[GCC GitHub mirror](https://gcc.gnu.org/wiki/GitMirror).

```sh
cmake -Dprefix=$HOME/gcc-devel -P build.cmake
```

This script sets environment variables during the build phase to avoid missing .so messages when building GCC.

The MacOS Apple Silicon build uses the GCC gcc-darwin-arm64 fork.

## Usage

Make a script like below and source it to use this GCC:

```sh
#!/usr/bin/env bash

prefix=$HOME/gcc-devel

case "$OSTYPE" in
  darwin*)
    export LIBRARY_PATH=$prefix/lib:$LIBRARY_PATH
  ;;
  linux*)
    export LD_LIBRARY_PATH=$prefix/lib64:$prefix/lib:$LD_LIBRARY_PATH
  ;;
esac

export PATH=$prefix/bin:$PATH

export CC=$prefix/bin/gcc CXX=$prefix/bin/g++ FC=$prefix/bin/gfortran
```
