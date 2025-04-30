cmake_minimum_required(VERSION 3.20...4.0)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed. Try 'cmake -B build'")
endif()

project(BuildGCC LANGUAGES C CXX)

include(GNUInstallDirs)
include(cmake/ExtProj.cmake)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

# must be before options.cmake
find_package(Autotools REQUIRED)
message(STATUS "Autotools: ${AUTOCONF_VERSION}")

include(options.cmake)

if(DEFINED ENV{CONDA_PREFIX})
  message(FATAL_ERROR "Please deactivate conda environment to avoid errors:
  conda deactivate")
endif()

find_program(awk NAMES awk REQUIRED)
message(STATUS "awk: ${awk}")


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
  TIMEOUT 10
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
  set(LIBRARY_PATH LIBRARY_PATH=${native_lib})
  if(DEFINED ENV{LIBRARY_PATH})
    # necessary to avoid GCC error
    # checking LIBRARY_PATH variable... contains current directory
    # configure: error:
    # *** LIBRARY_PATH shouldn't contain the current directory when
    # *** building gcc. Please change the environment variable
    # *** and run configure again.
    string(APPEND LIBRARY_PATH ":$ENV{LIBRARY_PATH}")
  endif()
  message(STATUS "${LIBRARY_PATH}")
elseif(UNIX)
  set(LD_LIBRARY_PATH LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH})
  message(STATUS "${LD_LIBRARY_PATH}")
endif()


message(STATUS "GCC: ${gcc_url}")
message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "LDFLAGS: ${LDFLAGS}")

include(cmake/gmp.cmake)
message(STATUS "GMP_ROOT: ${GMP_ROOT}")

include(cmake/isl.cmake)
message(STATUS "ISL_ROOT: ${ISL_ROOT}")

include(cmake/mpfr.cmake)
message(STATUS "MPFR_ROOT: ${MPFR_ROOT}")

include(cmake/mpc.cmake)
message(STATUS "MPC_ROOT: ${MPC_ROOT}")

if(zstd)
  include(cmake/zstd.cmake)
else()
  add_custom_target(ZSTD)
endif()

include(cmake/gcc.cmake)

file(GENERATE OUTPUT .gitignore CONTENT "*")

message(STATUS "Using ${Ncpu} parallel jobs")

include(FeatureSummary)

add_feature_info(ZSTD zstd "Zstandard compression library")
add_feature_info(ISL isl "Integer Set Library")
add_feature_info(Cpp cpp "C++ compiler")
add_feature_info(Fortran fortran "Fortran compiler")
add_feature_info(GCOV gcov "GNU coverage tool")
add_feature_info(LTO lto "Link Time Optimization")

feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)
