# CMake build GCC

Build [GCC](https://gcc.gnu.org/install/) natively for C, C++, Fortran languages.
Builds prerequisite libraries GMP, MPFR, and MPC from CMake.

The optional ISL for Graphite optimizations is by default on; disable ISL with `-Duse_isl=off`.

By default C++ and Fortran are enabled.
If desired to disable, add `-Dcpp=off` or `-Dfortran=off` to the CMake arguments.

By default Gcov coverage tool is enabled.
If desired to disable, add `-Dgcov=off` to the CMake arguments.

By default link time optimization is enabled.
If desired to disable, add `-Dlto=off` to the CMake arguments.

This avoids needing to manually download and configure each project.
This assumes fundamental [prerequisites](https://gcc.gnu.org/install/prerequisites.html)
such as libc, Autotools, Make, CMake are present.
The 3-stage
[compiler bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(compilers))
is enabled to help ensure a working, performant GCC.

To keep things simple, this CMake project assumes a Linux system with Autotools, Make, and a new-enough C/C++ compiler.
GCC will take 10s of minutes to build, even on a powerful workstation.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=$HOME/gcc-devel

LD_LIBRARY_PATH=$HOME/gcc-devel/lib:$LD_LIBRARY_PATH cmake --build build
```

Passing environment variable LD_LIBRARY_PATH to the build process is necessary to avoid missing .so messages when building GCC.

That will build GCC and install it to ~/gcc-devel.

By default, a recent release of GCC is built using source from the [GitHub mirror](https://gcc.gnu.org/wiki/GitMirror).
GCC [snapshot](https://gcc.gnu.org/pub/gcc/snapshots/LATEST-12/) may also be built by changing the "gcc_url" variable in CMakeLists.txt.

## Usage

Source these variables (according to the paths on your system) each time using this particular GCC is desired:

```
#!/bin/sh

cp=$HOME/gcc-devel

export LD_LIBRARY_PATH=$cp/lib64:$cp/lib:$LD_LIBRARY_PATH

export PATH=$cp/bin:$PATH

export CC=$cp/bin/gcc CXX=$cp/bin/g++ FC=$cp/bin/gfortran
```

## Caveats

Numerous platforms require specific patches that we don't currently implement, though it would usually be straightforward to do so.
Key examples needing patches include Apple Silicon, MSYS2, etc.
