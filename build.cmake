cmake_minimum_required(VERSION 3.21)

if(NOT bindir)
  set(bindir ${CMAKE_CURRENT_BINARY_DIR}/build)
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
COMMAND_ERROR_IS_FATAL ANY
)


execute_process(COMMAND ${CMAKE_COMMAND} --build ${bindir}
COMMAND_ERROR_IS_FATAL ANY
)
