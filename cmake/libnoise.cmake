# find_package(libnoise REQUIRED)
set(LIBNOISE_LIBRARY noise)
# set(LIBNOISE_INCLUDE_DIR /usr/include)
# message(STATUS "libnoise found with lib:'${LIBNOISE_LIBRARY}' and include:'${LIBNOISE_INCLUDE_DIR}'")

LIST(APPEND stdgl_libraries noise)
# INCLUDE_DIRECTORIES(${})
