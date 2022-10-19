cmake_minimum_required(VERSION 3.13)

if(NOT bindir)
  set(bindir ${CMAKE_CURRENT_LIST_DIR}/build)
endif()
get_filename_component(bindir ${bindir} ABSOLUTE)

if(NOT prefix)
  set(prefix ${bindir}/local)
endif()
get_filename_component(prefix ${prefix} ABSOLUTE)

set(conf_args -DCMAKE_INSTALL_PREFIX:PATH=${prefix})


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
  find_library(macsys
  NAMES System
  PATHS /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
  )
  if(NOT macsys)
    message(FATAL_ERROR "Failed to find libSystem")
  endif()
  get_filename_component(syslib_dir ${macsys} DIRECTORY)

  set(env LIBRARY_PATH=${prefix}/lib:${syslib_dir}:$ENV{LIBRARY_PATH})
elseif(UNIX)
  set(env LD_LIBRARY_PATH=${prefix}/lib:$ENV{LD_LIBRARY_PATH})
endif()

execute_process(COMMAND ${CMAKE_COMMAND} -E env ${env}
  ${CMAKE_COMMAND} --build ${bindir}
RESULT_VARIABLE ret
)
if(NOT ret EQUAL 0)
  message(FATAL_ERROR "Failed to build / install")
endif()
