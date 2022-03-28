# CMake build GCC

Build GCC (C, C++, Fortran) and prerequisite libraries GMP, MPFR, and MPC from CMake.

It assumes a Linux/Unix/MacOS-like system with Autotools, Make, and a new-enough C/C++ compiler.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/gcc-devel

cmake --build build
```

that will build GCC and install it to ~/gcc-devel.

The key feature of this project is the downloading and building are all handled from the simple command above, rather than several manual steps.

One could add options for cross-compiling etc. would be happy to consider such additions.
