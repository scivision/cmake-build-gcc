set(gcc_args
--prefix=${CMAKE_INSTALL_PREFIX}
--with-gmp=${GMP_ROOT}
--with-isl=${ISL_ROOT}
--with-mpc=${MPC_ROOT}
--with-mpfr=${MPFR_ROOT}
--disable-multilib
--enable-languages=c,c++,fortran
)

set(gcc_url https://bigsearcher.com/mirrors/gcc/releases/gcc-11.2.0/gcc-11.2.0.tar.xz)
set(gcc_sha512 d53a0a966230895c54f01aea38696f818817b505f1e2bfa65e508753fcd01b2aedb4a61434f41f3a2ddbbd9f41384b96153c684ded3f0fa97c82758d9de5c7cf)

ExternalProject_Add(gcc_compiler
URL ${gcc_url}
URL_HASH SHA512=${gcc_sha512}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "GMP;ISL;MPC;MPFR"
)
