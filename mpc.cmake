find_path(MPC_INCLUDE_DIR NAMES mpc.h)

find_library(MPC_LIBRARY NAMES mpc)

if(MPC_INCLUDE_DIR AND MPC_LIBRARY)
  add_custom_target(MPC)
  cmake_path(GET MPC_INCLUDE_DIR PARENT_PATH MPC_ROOT)
  return()
endif()

set(mpc_args
--prefix=${CMAKE_INSTALL_PREFIX}
--with-gmp=${GMP_ROOT}
--with-mpfr=${MPFR_ROOT}
)

set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz)

ExternalProject_Add(MPC
URL ${mpc_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${mpc_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "GMP;MPFR"
)

cmake_path(SET MPC_ROOT ${CMAKE_INSTALL_PREFIX})
