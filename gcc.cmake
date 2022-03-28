set(gcc_args
--prefix=${CMAKE_INSTALL_PREFIX}
)

set(gcc_url https://bigsearcher.com/mirrors/gcc/snapshots/LATEST-12/gcc-12-20220327.tar.xz)

ExternalProject_Add(gcc_compiler
URL ${gcc_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "GMP;MPC;MPFR"
)