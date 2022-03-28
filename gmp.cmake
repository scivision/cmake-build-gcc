# GMP
find_path(GMP_INCLUDE_DIR NAMES gmp.h)

find_library(GMP_LIBRARY NAMES gmp)

if(GMP_INCLUDE_DIR AND GMP_LIBRARY)
  add_custom_target(GMP)
  cmake_path(GET GMP_INCLUDE_DIR PARENT_PATH GMP_ROOT)
  return()
endif()

set(gmp_args
--prefix=${CMAKE_INSTALL_PREFIX}
)

set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.zst)

ExternalProject_Add(GMP
URL ${gmp_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gmp_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
)

cmake_path(SET GMP_ROOT ${CMAKE_INSTALL_PREFIX})
