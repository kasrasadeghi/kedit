FIND_PACKAGE(glm 0.9.8.0 QUIET)

INCLUDE_DIRECTORIES(${glm_INCLUDE_DIR})
message(STATUS "Using System glm")

add_definitions(-DGLM_ENABLE_EXPERIMENTAL -DGLM_FORCE_SIZE_FUNC=1 -DGLM_FORCE_RADIANS=1)
