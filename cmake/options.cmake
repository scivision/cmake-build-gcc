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

if(version)
  set(gcc_tag "releases/gcc-${version}")
endif()

if(NOT gcc_tag)
  set(gcc_tag releases/gcc-12.2.0)
endif()

# --- URLs

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  set(gcc_url https://github.com/iains/gcc-darwin-arm64.git)
  set(gcc_tag master-wip-apple-si)
else()
  set(gcc_url https://gcc.gnu.org/git/gcc.git)
  # https://github.com/gcc-mirror/gcc.git
endif()

set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.zst)
set(isl_url https://libisl.sourceforge.io/isl-0.25.tar.xz)
set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz)
set(mpfr_url https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz)

set(zstd_url https://github.com/facebook/zstd.git)
set(zstd_tag v1.5.2)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

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

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)
