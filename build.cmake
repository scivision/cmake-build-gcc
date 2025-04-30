cmake_minimum_required(VERSION 3.20)

if(NOT bindir)
  if(DEFINED ENV{TMPDIR})
    set(bindir $ENV{TMPDIR}/build_gcc)
  else()
    set(bindir /tmp/build_gcc)
  endif()
endif()
get_filename_component(bindir ${bindir} ABSOLUTE)

if(NOT prefix)
  message(FATAL_ERROR "please specify 'cmake -Dprefix=/path/to/install'")
endif()
get_filename_component(prefix ${prefix} ABSOLUTE)

set(conf_args --install-prefix=${prefix})
if(version)
  list(APPEND conf_args -Dversion=${version})
endif()
if(url)
  list(APPEND conf_args -Dgcc_url=${url})
endif()

execute_process(COMMAND ${CMAKE_COMMAND}
-S${CMAKE_CURRENT_LIST_DIR}
-B${bindir}
${conf_args}
COMMAND_ERROR_IS_FATAL ANY
)

execute_process(COMMAND ${CMAKE_COMMAND} --build ${bindir}
COMMAND_ERROR_IS_FATAL ANY
)
