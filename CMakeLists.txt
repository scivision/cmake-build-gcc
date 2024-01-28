cmake_minimum_required(VERSION 3.20...3.28)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed. Try 'cmake -B build'")
endif()

project(BuildGCC LANGUAGES C CXX)

include(GNUInstallDirs)
include(cmake/ExtProj.cmake)

include(options.cmake)

message(STATUS "Autotools: ${AUTOCONF_VERSION}")

set(LDFLAGS $ENV{LDFLAGS})
string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_FULL_LIBDIR}")
string(APPEND LDFLAGS " -Wl,-rpath,${CMAKE_INSTALL_FULL_LIBDIR}")

if(APPLE)
  # AppleClang 15.0:
  # ld: Assertion failed: (resultIndex < sectData.atoms.size()), function findAtom, file Relocations.cpp, line 1336.
  # https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes#Linking
  # maybe try old linker -ld64

  execute_process(COMMAND xcrun --sdk macosx --show-sdk-path
  OUTPUT_VARIABLE out OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY
  )
  message(STATUS "SDK Hint: ${out}")

  set(CMAKE_FIND_FRAMEWORK "NEVER")

  find_path(native_include NAMES stdio.h
  HINTS ${out}
  REQUIRED
  )
  string(APPEND CMAKE_C_FLAGS " -I${native_include}")

  find_library(macsys NAMES System
  HINTS ${out}/usr/lib
  REQUIRED
  )

  cmake_path(GET macsys PARENT_PATH native_lib)
  string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${native_lib}")
  string(APPEND LDFLAGS " -Wl,-rpath,${native_lib}")
  set(LIBRARY_PATH LIBRARY_PATH=${native_lib}:$ENV{LIBRARY_PATH})
  message(STATUS "${LIBRARY_PATH}")
elseif(UNIX)
  set(LD_LIBRARY_PATH LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH})
  message(STATUS "${LD_LIBRARY_PATH}")
endif()


message(STATUS "GCC: ${gcc_url}")
message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "LDFLAGS: ${LDFLAGS}")

# --- GMP
if(find_gmp)
  find_path(GMP_INCLUDE_DIR NAMES gmp.h)
  if(GMP_INCLUDE_DIR)
    cmake_path(GET GMP_INCLUDE_DIR PARENT_PATH GMP_ROOT)
    add_custom_target(GMP)
  endif()
endif()
if(NOT GMP_ROOT)
  extproj(GMP ${gmp_url} "" "")
  set(GMP_ROOT ${CMAKE_INSTALL_PREFIX})
  message(STATUS "GMP: ${gmp_url}")
endif()
message(STATUS "GMP_ROOT: ${GMP_ROOT}")

# --- ISL
if(isl)
  extproj(ISL ${isl_url} "--with-gmp-prefix=${GMP_ROOT}" "GMP")
  set(ISL_ROOT ${CMAKE_INSTALL_PREFIX})
else()
  add_custom_target(ISL)
endif()

# --- MPFR
extproj(MPFR ${mpfr_url} "--with-gmp=${GMP_ROOT}" "GMP")
set(MPFR_ROOT ${CMAKE_INSTALL_PREFIX})
message(STATUS "MPFR: ${mpfr_url}")
message(STATUS "MPFR_ROOT: ${MPFR_ROOT}")

# --- MPC
extproj(MPC ${mpc_url} "--with-gmp=${GMP_ROOT};--with-mpfr=${MPFR_ROOT}" "GMP;MPFR")
set(MPC_ROOT ${CMAKE_INSTALL_PREFIX})

if(zstd)
  include(cmake/zstd.cmake)
else()
  add_custom_target(ZSTD)
endif()

include(cmake/gcc.cmake)

file(GENERATE OUTPUT .gitignore CONTENT "*")

message(STATUS "Using ${NCPU} parallel jobs")

include(FeatureSummary)

add_feature_info(ZSTD zstd "Zstandard compression library")
add_feature_info(ISL isl "Integer Set Library")
add_feature_info(Cpp cpp "C++ compiler")
add_feature_info(Fortran fortran "Fortran compiler")
add_feature_info(GCOV gcov "GNU coverage tool")

feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)
