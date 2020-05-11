# Directories
LINK_DIRECTORIES("/usr/local/lib" "/opt/local/lib")
INCLUDE_DIRECTORIES("/usr/local/include" "/opt/local/include")
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

# Flags
#set(CMAKE_CXX_FLAGS "--std=c++14 -g -fmax-errors=1")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++17 -g -fdiagnostics-show-template-tree -fmax-errors=1 -ftemplate-backtrace-limit=1")

