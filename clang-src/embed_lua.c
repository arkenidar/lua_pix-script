
// gcc clang-src/embed_lua.c -o program-bin/embedlua -lm

#define LUA_IMPL
#include "minilua.h"

/*
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
*/

/*
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
*/

int DrawPoint(lua_State *L)
{
    // Check if the first argument is integer and return the value
    int x = luaL_checkinteger(L, 1);

    // Check if the second argument is integer and return the value
    int y = luaL_checkinteger(L, 2);

    printf("DrawPoint(%d,%d)\n", x, y);

    return 0;
}

int SetDrawColor(lua_State *L)
{
    int r = luaL_checkinteger(L, 1);
    int g = luaL_checkinteger(L, 2);
    int b = luaL_checkinteger(L, 3);

    printf("SetDrawColor(%d,%d,%d)\n", r, g, b);

    return 0;
}

int main(int argc, char **argv)
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    if (luaL_dofile(L, "lua-scripts/app.lua") == LUA_OK)
    {
        lua_pop(L, lua_gettop(L));
    }

    // Push the pointer to function
    lua_pushcfunction(L, DrawPoint);

    // Get the value on top of the stack
    // and set as a global, in this case is the function
    lua_setglobal(L, "DrawPoint");

    // Push the pointer to function
    lua_pushcfunction(L, SetDrawColor);

    // Get the value on top of the stack
    // and set as a global, in this case is the function
    lua_setglobal(L, "SetDrawColor");

    lua_getglobal(L, "Draw");
    if (lua_isfunction(L, -1))
    {
        if (lua_pcall(L, 0, 1, 0) == LUA_OK)
        {
            lua_pop(L, lua_gettop(L));
        }
    }

    lua_close(L);
    return 0;
}