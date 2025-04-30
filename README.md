# CMake build GCC

Build [GCC](https://gcc.gnu.org/install/)
natively for C, C++, Fortran languages.
Builds prerequisite libraries GMP, MPFR, and MPC from CMake.

Platforms working include:

* Linux (Intel / AMD CPU)

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
* macOS: `brew install cmake autoconf autoconf-archive libtool`

Automake is not required unless modifying GCC source code.

## Options

These options may be changed by adding the CMake configure arguments:

Set GCC version (Linux only, as macOS uses a GCC fork)
: `-Dgcc_version=14.2.0`

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

disable Zstd
: `-Dzstd=off`

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

Specify a URL say from [GCC snapshots](https://gcc.gnu.org/pub/gcc/snapshots/?C=M;O=D) like:

```sh
 cmake -Durl=https://gcc.gnu.org/pub/gcc/snapshots/LATEST-15/gcc-15-20240526.tar.xz -P build.cmake
 ```

macOS Apple Silicon may need the
[GCC gcc-darwin-arm64 fork](https://github.com/iains/gcc-darwin-arm64/):

```sh
cmake -Durl=https://github.com/iains/gcc-darwin-arm64/archive/refs/heads/master-wip-apple-si.zip -P build.cmake
```

## Usage

Source a script like [gcc-dev.sh](./gcc-dev.sh) to use this GCC.


[Troubleshooting](./troubleshooting.md)
