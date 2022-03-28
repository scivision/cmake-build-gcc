# CMake build GCC

Build GCC and prereqs GMP, MPFR, and MPC driven by CMake.

It assumes a Linux/Unix/MacOS-like system with Autotools, Make, and a new-enough C/C++ compiler.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/gcc-devel

cmake --build build
```

that will build GCC and install it to ~/gcc-devel.
