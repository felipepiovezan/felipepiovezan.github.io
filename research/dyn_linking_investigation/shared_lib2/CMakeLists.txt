add_library(shared_lib2 SHARED shared_lib2_src.cpp)
target_link_libraries(shared_lib2 PUBLIC lib_global_ctor)
target_include_directories(shared_lib2 PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
