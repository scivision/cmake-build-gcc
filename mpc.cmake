set(mpc_args
--prefix=${CMAKE_INSTALL_PREFIX}
--with-gmp=${GMP_ROOT}
--with-mpfr=${MPFR_ROOT}
)

set(mpc_url https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz)

ExternalProject_Add(MPC
URL ${mpc_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${mpc_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "GMP;MPFR"
)

cmake_path(SET MPC_ROOT ${CMAKE_INSTALL_PREFIX})
