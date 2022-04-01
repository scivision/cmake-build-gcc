# CMake build GCC

Build [GCC](https://gcc.gnu.org/install/) natively for C, C++, Fortran languages.
Builds prerequisite libraries GMP, MPFR, and MPC from CMake.
There is optional ISL for Graphite optimizations, which takes longer to build GCC itself.
By default ISL is off; enable ISL with `-Duse_isl=on`.

This avoids needing to manually download and configure each project.
This assumes fundamental [prerequisites](https://gcc.gnu.org/install/prerequisites.html)
such as libc, Autotools, Make, CMake are present.
The 3-stage
[compiler bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(compilers))
is enabled to help ensure a working, performant GCC.

It assumes a Linux/Unix/MacOS-like system with Autotools, Make, and a new-enough C/C++ compiler.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=$HOME/gcc-devel

# Linux
LD_LIBRARY_PATH=$HOME/gcc-devel:$LD_LIBRARY_PATH cmake --build build
```

Passing environment variable LD_LIBRARY_PATH to the build process is necessary to avoid missing .so messages when building GCC.

That will build GCC and install it to ~/gcc-devel.

By default, a recent release of GCC is built.
To specify GCC source URL, for example to build a [snapshot](https://gcc.gnu.org/pub/gcc/snapshots/LATEST-12/) specify the source archive URL with `-Dgcc_url=<url>`.

## Caveats

Numerous platforms require specific patches that we don't currently implement, though it would usually be straightforward to do so.
Key examples needing patches include Apple Silicon, MSYS2, etc.
