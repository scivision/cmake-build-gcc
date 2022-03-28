cmake_minimum_required(VERSION 3.20...3.23)

project(BuildGCC LANGUAGES NONE)

include(ExternalProject)


# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

set(CMAKE_TLS_VERIFY true)

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

# Make
find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)

# GMP
find_path(GMP_INCLUDE_DIR
NAMES gmp.h
REQUIRED
)

find_library(GMP_LIBRARY
NAMES gmp
REQUIRED
)

# MPFR
find_path(MPFR_INCLUDE_DIR
NAMES mpfr.h
REQUIRED
)

find_library(MPFR_LIBRARY
NAMES mpfr
REQUIRED
)

# MPC
find_path(MPC_INCLUDE_DIR
NAMES mpc.h
REQUIRED
)

find_library(MPC_LIBRARY
NAMES mpc
REQUIRED
)

set(gcc_args)

ExternalProject_Add(gcc_compiler
URL https://bigsearcher.com/mirrors/gcc/snapshots/LATEST-12/gcc-12-20220327.tar.xz
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j ${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j ${Ncpu} install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
)

set(gcc_url https://bigsearcher.com/mirrors/gcc/snapshots/LATEST-12/gcc-12-20220327.tar.xz)
set(gcc_args)

ExternalProject_Add(gcc_compiler
URL ${gcc_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j ${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j ${Ncpu} install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
)
