set(isl_args
--prefix=${CMAKE_INSTALL_PREFIX}
--with-gmp-prefix=${GMP_ROOT}
)

set(isl_url https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2)

ExternalProject_Add(ISL
URL ${isl_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${isl_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "GMP"
)

cmake_path(SET ISL_ROOT ${CMAKE_INSTALL_PREFIX})
