# This is for autotools based projects
include(ExternalProject)


function(extproj name url args dep)

list(PREPEND args "--prefix=${CMAKE_INSTALL_PREFIX}")

if(run_tests)
  set(test_cmd ${MAKE_EXECUTABLE} -j${Ncpu} check)
else()
  set(test_cmd "")
endif()

ExternalProject_Add(${name}
URL ${url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS} MAKEINFO=true
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu} MAKEINFO=true
INSTALL_COMMAND ${MAKE_EXECUTABLE} install
TEST_COMMAND ${test_cmd}
DEPENDS ${dep}
CONFIGURE_HANDLED_BY_BUILD ON
USES_TERMINAL_DOWNLOAD true
USES_TERMINAL_UPDATE true
USES_TERMINAL_PATCH true
USES_TERMINAL_CONFIGURE true
USES_TERMINAL_BUILD true
USES_TERMINAL_INSTALL true
USES_TERMINAL_TEST true
)
# MAKEINFO=true disables docs using makeinfo to save time and avoid missing makeinfo error

endfunction(extproj)
