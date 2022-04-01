set(gmp_args
--prefix=${CMAKE_INSTALL_PREFIX}
)

set(gmp_url https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.zst)

ExternalProject_Add(GMP
URL ${gmp_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gmp_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
)

cmake_path(SET GMP_ROOT ${CMAKE_INSTALL_PREFIX})
