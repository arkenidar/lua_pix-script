
// gcc clang-src/embed_lua.c -o program-bin/embedlua -lm

#define LUA_IMPL
#include "minilua.h"

int main()
{
    lua_State *L = luaL_newstate();
    if (L == NULL)
        return -1;
    luaL_openlibs(L);
    // luaL_loadstring(L, "print 'hello world'");
    luaL_loadstring(L, "dofile('lua-scripts/app.lua')");
    lua_call(L, 0, 0);
    lua_close(L);
    return 0;
}