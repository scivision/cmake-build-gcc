option(cpp "enable C++ in GCC" true)
option(fortran "enable Fortran in GCC" true)

option(isl "Use ISL Graphite optimization" true)
option(zstd "enable ZSTD compression" true)

option(gcov "enable Gcov coverage tool" false)

option(lto "enable LTO" false)

option(CMAKE_TLS_VERIFY "verify TLS certificates" true)

option(find_gmp "find GMP" true)
option(find_mpfr "find MPFR" true)

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  # FAIL: isl_test_cpp
  option(run_tests "run tests for numerical prereqs (GMP, ISL, MPC, MPFR)")
else()
  option(run_tests "run tests for numerical prereqs (GMP, ISL, MPC, MPFR)" true)
endif()

if(NOT version AND NOT gcc_url)
  set(version 13.2.0)
endif()

# https://gmplib.org/
set(gmp_version 6.3.0)

# https://libisl.sourceforge.io/?C=M;O=D
set(isl_version 0.26)

# https://www.multiprecision.org/mpc/download.html
set(mpc_version 1.3.1)

# https://www.mpfr.org/mpfr-current/
set(mpfr_version 4.2.1)

# https://github.com/facebook/zstd/releases
set(zstd_version 1.5.5)

# --- URLs
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

find_package(Autotools REQUIRED)

if(NOT gcc_url)
if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  set(gcc_url https://github.com/iains/gcc-darwin-arm64/archive/refs/heads/master-wip-apple-si.zip)
else()
  set(gcc_url https://ftp.gnu.org/gnu/gcc/gcc-${version}/gcc-${version}.tar.xz)
endif()
endif()

set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-${gmp_version}.tar.zst)
set(isl_url https://libisl.sourceforge.io/isl-${isl_version}.tar.xz)

set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-${mpc_version}.tar.gz)


if(AUTOCONF_VERSION VERSION_LESS 2.71)
  set(mpfr_version 4.1.0)
  message(STATUS "MPFR ${mpfr_version} due to autoconf < 2.71")
else()
endif()
set(mpfr_url https://ftp.gnu.org/gnu/mpfr/mpfr-${mpfr_version}.tar.xz)

set(zstd_url https://github.com/facebook/zstd/archive/refs/tags/v${zstd_version}.tar.gz)

# users can specify like "cmake -B build -DCMAKE_INSTALL_PREFIX=~/mydir"
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/local CACHE PATH "..." FORCE)
endif()

message(STATUS "Install prefix: ${CMAKE_INSTALL_PREFIX}")


# --- limit CPU to avoid slowdown due to several hundred parallel threads
cmake_host_system_information(RESULT NCPU QUERY NUMBER_OF_PHYSICAL_CORES)
if(NCPU LESS 1)
  set(NCPU)
endif()

set(BUILD_SHARED_LIBS true)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)
