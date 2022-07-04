cmake_minimum_required(VERSION 3.14)
project(dynamic_linking_global_ctors)
set(CMAKE_BUILD_TYPE Debug)

add_library(project_requirements INTERFACE)
# set_target_properties(project_requirements PROPERTIES
#   CXX_STANDARD_REQUIRED ON
#   CXX_STANDARD 20
# )
target_compile_features(project_requirements INTERFACE cxx_std_20)

add_subdirectory(lib_global_ctor)
add_subdirectory(shared_lib1)
add_subdirectory(shared_lib2)
add_subdirectory(executable)
