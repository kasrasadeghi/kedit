CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

project(kedit)
message("project: " ${CMAKE_PROJECT_NAME})

# create stdgl_libraries and aux_sources
FILE(GLOB cmakes ${CMAKE_SOURCE_DIR}/cmake/*.cmake)
FOREACH(cmake ${cmakes})
	INCLUDE(${cmake})
ENDFOREACH(cmake)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# NOTE:
#   stdgl_libraries ::= opengl related libraries are stored in
#   lib_source_dirs ::= auxiliary source directories for the main project
MESSAGE(STATUS "stdgl: ${stdgl_libraries}")
MESSAGE(STATUS "lib sources: ${lib_source_dirs}")

if (GTEST)
	ADD_SUBDIRECTORY(test)
else (GTEST)
	ADD_SUBDIRECTORY(src)
endif (GTEST)
