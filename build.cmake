cmake_minimum_required(VERSION 3.21)

if(NOT bindir)
  if(DEFINED ENV{TMPDIR})
    set(bindir $ENV{TMPDIR}/build_gcc)
  elseif(DEFINED ENV{TEMP})
    set(bindir $ENV{TEMP}/build_gcc)
  else()
    set(bindir ${CMAKE_CURRENT_BINARY_DIR}/build_gcc)
  endif()
endif()
file(REAL_PATH ${bindir} bindir EXPAND_TILDE)

if(NOT prefix)
  set(prefix ${bindir}/local)
endif()
file(REAL_PATH ${prefix} prefix EXPAND_TILDE)

set(conf_args --install-prefix=${prefix})
if(version)
  list(APPEND conf_args -Dversion=${version})
endif()


execute_process(COMMAND ${CMAKE_COMMAND}
-S${CMAKE_CURRENT_LIST_DIR}
-B${bindir}
${conf_args}
RESULT_VARIABLE ret
)
if(NOT ret EQUAL 0)
  message(FATAL_ERROR "Failed to configure")
endif()

# --- build

if(APPLE)
  execute_process(COMMAND xcrun --sdk macosx --show-sdk-path
  RESULT_VARIABLE ret
  OUTPUT_VARIABLE out
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  message(STATUS "SDK Hint: ${out}")

  set(CMAKE_FIND_FRAMEWORK "NEVER")
  find_library(macsys NAMES System
  PATHS ${out}/usr/lib
  REQUIRED
  )
  cmake_path(GET macsys PARENT_PATH syslib_dir)

  set(env LIBRARY_PATH=${syslib_dir})
elseif(UNIX)
  set(env LD_LIBRARY_PATH=${prefix}/lib:$ENV{LD_LIBRARY_PATH})
endif()

message(STATUS "Build with amended environment:
 ${env}")

execute_process(COMMAND ${CMAKE_COMMAND} -E env ${env}
  ${CMAKE_COMMAND} --build ${bindir}
RESULT_VARIABLE ret
)
if(NOT ret EQUAL 0)
  message(FATAL_ERROR "Failed to build / install")
endif()
