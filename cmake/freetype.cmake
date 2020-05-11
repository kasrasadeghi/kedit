find_package(Freetype REQUIRED)
message(STATUS "Freetype libraries found: " ${FREETYPE_LIBRARIES})
message(STATUS "Freetype include dir found: " ${FREETYPE_INCLUDE_DIRS})

include_directories(
  ${FREETYPE_INCLUDE_DIRS}
)

link_libraries(
  ${FREETYPE_LIBRARIES}
)