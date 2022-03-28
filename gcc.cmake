set(gcc_args
--prefix=${CMAKE_INSTALL_PREFIX}
--with-gmp=${GMP_ROOT}
--with-mpc=${MPC_ROOT}
--with-mpfr=${MPFR_ROOT}
--disable-multilib
--enable-languages=c,c++,fortran
)

set(gcc_url https://bigsearcher.com/mirrors/gcc/snapshots/LATEST-12/gcc-12-20220327.tar.xz)

ExternalProject_Add(gcc_compiler
URL ${gcc_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "GMP;MPC;MPFR"
)
