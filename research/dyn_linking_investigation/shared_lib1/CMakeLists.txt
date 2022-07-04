add_library(shared_lib1 SHARED shared_lib1_src.cpp)
target_link_libraries(shared_lib1 PUBLIC lib_global_ctor)
target_include_directories(shared_lib1 PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
