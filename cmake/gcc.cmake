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
  list(APPEND gcc_args --with-zstd=${ZSTD_ROOT} --with-zstd-lib=${ZSTD_ROOT}/${CMAKE_INSTALL_LIBDIR})
endif()


if(gcc_url MATCHES ".git$")
  set(gcc_download
  GIT_REPOSITORY ${gcc_url}
  GIT_TAG ${gcc_tag}
  GIT_SHALLOW true
  GIT_PROGRESS true)
else()
  set(gcc_download URL ${gcc_url})
endif()

ExternalProject_Add(GCC
${gcc_download}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${gcc_args} ${gcc_lang} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${NCPU}
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j${NCPU} install
TEST_COMMAND ""
DEPENDS "GMP;ISL;MPC;MPFR;ZSTD"
TLS_VERIFY true
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 60
)
