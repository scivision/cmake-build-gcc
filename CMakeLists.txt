cmake_minimum_required(VERSION 3.13...3.25)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed. Try 'cmake -B build'")
endif()

project(BuildGCC LANGUAGES C CXX)

include(GNUInstallDirs)
include(cmake/ExtProj.cmake)

include(cmake/options.cmake)

set(LDFLAGS $ENV{LDFLAGS})
string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_PREFIX}/lib")
string(APPEND LDFLAGS " -Wl,-rpath,${CMAKE_INSTALL_PREFIX}/lib")

if(APPLE)
  execute_process(COMMAND xcrun --sdk macosx --show-sdk-path
  RESULT_VARIABLE ret
  OUTPUT_VARIABLE out
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  message(STATUS "SDK Hint: ${out}")

  set(CMAKE_FIND_FRAMEWORK "NEVER")
  set(CMAKE_FIND_LIBRARY_PREFIXES "")

  find_path(native_include NAMES stdio.h
  HINTS ${out}
  )
  if(native_include)
    string(APPEND CMAKE_C_FLAGS " -I${native_include}")
  endif()

  find_library(macsys NAMES System
  HINTS ${out}/System/Library/Frameworks/System.framework
  )

  if(macsys)
    get_filename_component(native_lib ${macsys} DIRECTORY)
    string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${native_lib}")
    string(APPEND LDFLAGS " -Wl,-rpath,${native_lib}")
  endif()
endif()


message(STATUS "GCC: ${gcc_url} ${gcc_tag}")
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

include(cmake/zstd.cmake)

include(cmake/gcc.cmake)
