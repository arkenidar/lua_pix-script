cmake_minimum_required( VERSION 3.10 )
project( app_project VERSION 0.1 LANGUAGES C )

add_executable( sdl "clang-src/sdl.c" )
add_executable( embed_lua "clang-src/embed_lua.c" )

find_package( SDL2 REQUIRED )

# MinGW64 in Windows (MSYS2-MinGW64)
# gcc embed_test_01.c -L/home/dario/luajit/src -I/home/dario/luajit/src -lluajit-5.1.dll # Windows 11 , using MSYS2-MinGW64
if (WIN32)
    link_directories( c:/MSYS64/home/dario/luajit/src )
    include_directories( c:/MSYS64/home/dario/luajit/src )

    # variant: no console window on Windows (Wine also works)
    # WARNING : when using this will not PRINT to stdout console !!! not good if debugging !
    #### target_link_options( sdl PRIVATE -mwindows ) # uncomment for Windows (MinGW)

    target_link_libraries( sdl ${SDL2_LIBRARIES} m luajit-5.1.dll )
    target_link_libraries( embed_lua ${SDL2_LIBRARIES} m luajit-5.1.dll )
endif (WIN32)

# apt-file show libluajit-5.1-dev # Debian 12 or Ubuntu 24.04.01 LTS
# pkg-config --cflags --libs luajit
# # Ubuntu 24.04.01 LTS : /usr/lib/x86_64-linux-gnu/pkgconfig/luajit.pc
# -I/usr/include/luajit-2.1 -lluajit-5.1

if (UNIX)
    include_directories(/usr/include/luajit-2.1)
    target_link_libraries( sdl ${SDL2_LIBRARIES} m luajit-5.1 )
    target_link_libraries( embed_lua ${SDL2_LIBRARIES} m luajit-5.1 )
endif (UNIX)
