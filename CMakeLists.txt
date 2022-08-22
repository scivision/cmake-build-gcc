cmake_minimum_required(VERSION 3.13...3.25)

project(BuildGCC LANGUAGES C CXX)

include(ExternalProject)
include(GNUInstallDirs)

include(ExtProj.cmake)

option(isl "Use ISL Graphite optimization" true)
option(cpp "enable C++ in GCC" true)
option(fortran "enable Fortran in GCC" true)
option(gcov "enable Gcov coverage tool" true)
option(lto "enable LTO" true)
option(zstd "enable ZSTD compression" true)

if(NOT gcc_tag)
  set(gcc_tag releases/gcc-12.2.0)
endif()

# --- URLs

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  set(gcc_url https://github.com/iains/gcc-darwin-arm64.git)
  set(gcc_tag master-wip-apple-si)
else()
  set(gcc_url https://github.com/gcc-mirror/gcc.git)
endif()


message(STATUS "GCC: ${gcc_url} ${gcc_tag}")

set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.zst)
set(isl_url https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2)
set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz)
set(mpfr_url https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz)

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

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)

set(LDFLAGS $ENV{LDFLAGS})
string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_PREFIX}/lib")
string(APPEND LDFLAGS " -Wl,-rpath,${CMAKE_INSTALL_PREFIX}/lib")

if(APPLE)
  find_path(native_include
  NAMES stdio.h
  PATHS /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
  )
  if(native_include)
    string(APPEND CMAKE_C_FLAGS " -I${native_include}")
  endif()

  find_library(macsys
  NAMES System
  NO_DEFAULT_PATH
  PATHS /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
  )
  if(macsys)
    get_filename_component(native_lib ${macsys} DIRECTORY)
    string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${native_lib}")
    string(APPEND LDFLAGS " -Wl,-rpath,${native_lib}")
  endif()
endif()

message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "LDFLAGS: ${LDFLAGS}")

# --- GMP
extproj(GMP ${gmp_url} "" "")
set(GMP_ROOT ${CMAKE_INSTALL_PREFIX})

# --- ISL
extproj(ISL ${isl_url} "--with-gmp-prefix=${GMP_ROOT}" "GMP")
set(ISL_ROOT ${CMAKE_INSTALL_PREFIX})

# --- MPFR
extproj(MPFR ${mpfr_url} "--with-gmp=${GMP_ROOT}" "GMP")
set(MPFR_ROOT ${CMAKE_INSTALL_PREFIX})

# --- MPC
extproj(MPC ${mpc_url} "--with-gmp=${GMP_ROOT};--with-mpfr=${MPFR_ROOT}" "GMP;MPFR")
set(MPC_ROOT ${CMAKE_INSTALL_PREFIX})

include(zstd.cmake)

include(gcc.cmake)
