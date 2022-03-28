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

include(gmp.cmake)

include(mpfr.cmake)

include(mpc.cmake)

include(gcc.cmake)
