# CMake build GCC

[Configure](https://gcc.gnu.org/install/configure.html)
and build
[GCC](https://gcc.gnu.org/install/)
natively for C, C++, Fortran languages.
Find or build GCC prerequisite libraries GMP, MPFR, and MPC from CMake.

Platforms working include:

* Linux (Intel / AMD CPU)
* macOS: Currently requires GCC fork for Apple Silicon `cmake -Dgcc_url=https://github.com/iains/gcc-darwin-arm64/archive/refs/heads/master-wip-apple-si.zip`

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

Build prerequisites are:

* CentOS: `dnf install cmake make autoconf autoconf-archive libtool`
* Ubuntu: `apt install cmake make autoconf autoconf-archive libtool`
* macOS: `brew install cmake autoconf autoconf-archive libtool`

Automake is not required unless modifying GCC source code.

If one wishes to install GCC prerequisites via a package manager, optionally do like:

* macOS `brew install gmp mpfr libmpc isl`

## Options

These options may be changed by adding the CMake configure arguments:

Set GCC version
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

We set GCC options like:

* `--disable-nls` to avoid gettext dependencies, make GCC output English only
* `--disable-multilib` to avoid building 32-bit libraries on 64-bit systems

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
 cmake -Dgcc_url=https://gcc.gnu.org/pub/gcc/snapshots/LATEST-15/gcc-15-20240526.tar.xz -P build.cmake
 ```

### Apple Silicon

macOS Apple Silicon may need the
[GCC gcc-darwin-arm64 fork](https://github.com/iains/gcc-darwin-arm64/):

```sh
cmake -Dgcc_url=https://github.com/iains/gcc-darwin-arm64/archive/refs/heads/master-wip-apple-si.zip -P build.cmake
```

`--with-system-zlib` for macOS avoids incompatible Zlib GCC-vendored headers.
Linux is OK with or without this flag.

## Usage

Source a script like [gcc-dev.sh](./gcc-dev.sh) to use this GCC.


[Troubleshooting](./troubleshooting.md)
