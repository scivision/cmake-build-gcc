# This is for autotools based projects
include(ExternalProject)


function(extproj name url args dep)

list(INSERT args 0 "--prefix=${CMAKE_INSTALL_PREFIX}")

if(run_tests)
  set(test_cmd ${MAKE_EXECUTABLE} -j${NCPU} check)
else()
  set(test_cmd)
endif()

ExternalProject_Add(${name}
URL ${url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS} MAKEINFO=true
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${NCPU} MAKEINFO=true
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j${NCPU} install
TEST_COMMAND ${test_cmd}
DEPENDS ${dep}
TLS_VERIFY true
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 60
)
# MAKEINFO=true disables docs using makeinfo to save time and avoid missing makeinfo error

endfunction(extproj)
