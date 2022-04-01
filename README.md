# CMake build GCC

Build GCC (C, C++, Fortran) and prerequisite libraries GMP, MPFR, and MPC from CMake.
There is optional ISL for Graphite optimizations, which takes much longer to build GCC itself.
By default ISL is off.

It assumes a Linux/Unix/MacOS-like system with Autotools, Make, and a new-enough C/C++ compiler.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=$HOME/gcc-devel

# Linux
LD_LIBRARY_PATH=$HOME/gcc-devel:$LD_LIBRARY_PATH cmake --build build
```

Passing environment variable LD_LIBRARY_PATH to the build process is necessary to avoid missing .so messages when building GCC.

That will build GCC and install it to ~/gcc-devel.

## Advantages

The key feature of this project is the downloading and building are all handled from the simple command above, rather than several manual steps.

One could add options for cross-compiling etc. would be happy to consider such additions.

## Downsides

Individual GCC snapshots as used here may be broken.
Numerous platforms require specific patches that we don't currently implement, though it would usually be straightforward to do so.
Key examples needing patches include Apple Silicon, MSYS2, etc.
