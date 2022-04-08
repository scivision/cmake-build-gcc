cmake_minimum_required(VERSION 3.20...3.23)

project(BuildGCC LANGUAGES C CXX)

include(ExternalProject)

option(use_isl "Use ISL Graphite optimization" true)
option(cpp "enable C++ in GCC" true)
option(fortran "enable Fortran in GCC" true)
option(gcov "enable Gcov coverage tool" true)
option(lto "enable LTO" true)

# --- URLs

set(gcc_url https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-11.2.0.tar.gz)
set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.zst)
set(isl_url https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2)
set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz)
set(mpfr_url https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

# users can specify like "cmake -B build -DCMAKE_INSTALL_PREFIX=~/mydir"
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "please specify install prefix like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/gcc-dev"
  )
endif()

set(CMAKE_TLS_VERIFY true)

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)

set(LDFLAGS $ENV{LDFLAGS})
string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_PREFIX}/lib")
string(APPEND LDFLAGS " -Wl,-rpath,${CMAKE_INSTALL_PREFIX}/lib")

foreach(t gmp isl mpfr mpc gcc)
  include(${t}.cmake)
endforeach()
