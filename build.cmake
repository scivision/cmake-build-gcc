cmake_minimum_required(VERSION 3.13)

if(NOT bindir)
  set(bindir /tmp/build_gcc)
endif()
get_filename_component(bindir ${bindir} ABSOLUTE)

if(NOT prefix)
  set(prefix ${bindir}/local)
endif()
get_filename_component(prefix ${prefix} ABSOLUTE)

set(conf_args -DCMAKE_INSTALL_PREFIX:PATH=${prefix})
if(version)
  list(APPEND conf_args -Dversion=${version})
endif()


execute_process(COMMAND ${CMAKE_COMMAND}
-G "Unix Makefiles"
-S${CMAKE_CURRENT_LIST_DIR}
-B${bindir}
${conf_args}
RESULT_VARIABLE ret
)
# Make shows live ExternalProject progress while Ninja is quiet
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
  set(CMAKE_FIND_LIBRARY_PREFIXES "")
  find_library(macsys NAMES System
  PATHS ${out}/System/Library/Frameworks/System.framework
  )
  if(NOT macsys)
    message(FATAL_ERROR "Failed to find System.tbd")
  endif()
  get_filename_component(syslib_dir ${macsys} DIRECTORY)

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
