cmake_minimum_required( VERSION 3.10 )
project( app_project VERSION 0.1 LANGUAGES C )

add_executable( sdl "clang-src/sdl.c" )
add_executable( embed_lua "clang-src/embed_lua.c" )

find_package( SDL2 REQUIRED )

target_link_libraries( sdl ${SDL2_LIBRARIES} m )
target_link_options( sdl PRIVATE -mwindows )

target_link_libraries( embed_lua ${SDL2_LIBRARIES} m )
