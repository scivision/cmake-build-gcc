option(isl "Use ISL Graphite optimization" true)
option(cpp "enable C++ in GCC" true)
option(fortran "enable Fortran in GCC" true)
option(gcov "enable Gcov coverage tool" true)
option(lto "enable LTO" true)
option(zstd "enable ZSTD compression" true)

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  # FAIL: isl_test_cpp
  option(run_tests "run tests for numerical prereqs (GMP, ISL, MPC, MPFR)")
else()
  option(run_tests "run tests for numerical prereqs (GMP, ISL, MPC, MPFR)" true)
endif()

if(NOT version)
  set(version 12.2.0)
endif()

# if(NOT gcc_tag)
#   set(gcc_tag releases/gcc-12.2.0)
# endif()

# --- URLs
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

find_package(Autotools REQUIRED)

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  set(gcc_url https://github.com/iains/gcc-darwin-arm64.git)
  set(gcc_tag master-wip-apple-si)
else()
  set(gcc_url https://ftp.gnu.org/gnu/gcc/gcc-${version}/gcc-${version}.tar.xz)
  # https://gcc.gnu.org/git/gcc.git
  # https://github.com/gcc-mirror/gcc.git
endif()

set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.zst)
set(isl_url https://libisl.sourceforge.io/isl-0.25.tar.xz)

# MPC 1.3.0 has missing #include <stdio.h> in mpc.h, leading to GCC failure to find mpc.
# this may have been fixed in https://gitlab.inria.fr/mpc/mpc/-/commit/e944aa454e60cbff8ab4e8c70dd974083398378f
# mpc.h:287:35: error: unknown type name 'FILE'
# __MPC_DECLSPEC void mpcr_out_str (FILE *f, mpcr_srcptr r);
# mpc.h:287:35: note: 'FILE' is defined in header '<stdio.h>'; did you forget to '#include <stdio.h>'?
set(mpc_version 1.2.1)
set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-${mpc_version}.tar.gz)

set(mpfr_version 4.1.1)
if(AUTOCONF_VERSION VERSION_LESS 2.71)
  set(mpfr_version 4.1.0)
endif()
set(mpfr_url https://ftp.gnu.org/gnu/mpfr/mpfr-${mpfr_version}.tar.xz)

set(zstd_url https://github.com/facebook/zstd.git)
set(zstd_tag v1.5.2)


# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

# users can specify like "cmake -B build -DCMAKE_INSTALL_PREFIX=~/mydir"
message(STATUS "Install prefix: ${CMAKE_INSTALL_PREFIX}")
file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX})

# --- limit CPU to avoid slowdown due to several hundred parallel threads
cmake_host_system_information(RESULT NCPU QUERY NUMBER_OF_PHYSICAL_CORES)
if(NCPU LESS 1)
  set(NCPU)
endif()

set(CMAKE_TLS_VERIFY true)
set(BUILD_SHARED_LIBS true)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)
