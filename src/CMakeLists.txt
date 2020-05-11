# build sources
SET(src "")

# add current directory to sources
SET(current_dir ${CMAKE_CURRENT_LIST_DIR})
aux_source_directory(${current_dir} src)

# add library src_directories to sources
foreach(x IN LISTS lib_source_dirs)
  aux_source_directory(${x} src)
endforeach(x IN lib_source_dirs)

# build project with sources and standard gl libraries
message(STATUS ${CMAKE_PROJECT_NAME} " added ${src}")
add_executable(${CMAKE_PROJECT_NAME} ${src})
target_link_libraries(${CMAKE_PROJECT_NAME} ${stdgl_libraries})
