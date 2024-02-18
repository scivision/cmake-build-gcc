# option reference: https://github.com/Homebrew/homebrew-core/blob/master/Formula/g/gcc.rb

set(gcc_args
--prefix=${CMAKE_INSTALL_PREFIX}
--with-gmp=${GMP_ROOT}
--with-mpc=${MPC_ROOT}
--with-mpfr=${MPFR_ROOT}
--disable-multilib
--disable-nls
)

if(native_include)
  list(APPEND gcc_args --with-native-system-header-dir=${native_include})
endif()

set(gcc_lang --enable-languages=c)
if(cpp)
  string(APPEND gcc_lang ",c++")
endif()
if(fortran)
  string(APPEND gcc_lang ",fortran")
endif()

if(isl)
  list(APPEND gcc_args --with-isl=${ISL_ROOT})
endif()

if(NOT gcov)
  list(APPEND gcc_args --disable-gcov)
endif()

if(NOT lto)
  list(APPEND gcc_args --disable-lto)
endif()

if(zstd)
  list(APPEND gcc_args --with-zstd=${ZSTD_ROOT})
endif()

message(STATUS "GCC args: ${gcc_args}")

ExternalProject_Add(GCC
URL ${gcc_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args} ${gcc_lang} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${CMAKE_COMMAND} -E env ${LIBRARY_PATH} ${LD_LIBRARY_PATH} ${MAKE_EXECUTABLE} -j${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} install
TEST_COMMAND ""
DEPENDS "GMP;ISL;MPC;MPFR;ZSTD"
CONFIGURE_HANDLED_BY_BUILD ON
USES_TERMINAL_DOWNLOAD true
USES_TERMINAL_UPDATE true
USES_TERMINAL_PATCH true
USES_TERMINAL_CONFIGURE true
USES_TERMINAL_BUILD true
USES_TERMINAL_INSTALL true
USES_TERMINAL_TEST true
)
