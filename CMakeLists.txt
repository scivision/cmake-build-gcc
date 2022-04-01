cmake_minimum_required(VERSION 3.20...3.23)

project(BuildGCC LANGUAGES C CXX)

include(ExternalProject)


# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

# --- default install directory under build/local
# users can specify like "cmake -B build -DCMAKE_INSTALL_PREFIX=~/mydir"
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "please specify install prefix like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/gcc-dev"
  )
endif()

option(use_isl "Use ISL Graphite optimization")

if(NOT gcc_url)
  set(gcc_url https://bigsearcher.com/mirrors/gcc/releases/gcc-11.2.0/gcc-11.2.0.tar.xz)
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
