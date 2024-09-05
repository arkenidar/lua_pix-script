// Include the SDL2 library
#include <SDL2/SDL.h>

// Include the standard I/O library
#include <stdio.h>

// Include the standard library for random numbers (and seed the random number generator)
#include <time.h>
#include <stdlib.h>

// Include for Lua

// minilua
// #define LUA_IMPL
// #include "minilua.h"

// lua or luajit
// /*
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
// */

SDL_Renderer *renderer;

int DrawPoint(lua_State *L)
{
    // Check if the first argument is integer and return the value
    int x = luaL_checkinteger(L, 1);

    // Check if the second argument is integer and return the value
    int y = luaL_checkinteger(L, 2);

    // printf("DrawPoint(%d,%d)\n", x, y);
    SDL_RenderDrawPoint(renderer, x, y);

    return 0;
}

int SetDrawColor(lua_State *L)
{
    int r = luaL_checkinteger(L, 1);
    int g = luaL_checkinteger(L, 2);
    int b = luaL_checkinteger(L, 3);

    // printf("SetDrawColor(%d,%d,%d)\n", r, g, b);
    SDL_SetRenderDrawColor(renderer, r, g, b, SDL_ALPHA_OPAQUE);

    return 0;
}

int main(int argc, char *argv[])
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

    //----------------------------------

    // Seed the random number generator
    srand(time(NULL));

    // Initialize SDL
    if (SDL_Init(SDL_INIT_VIDEO) < 0)
    {
        printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
        return 1;
    }

    // Create a window
    SDL_Window *window = SDL_CreateWindow("SDL2 Window -- Rectangles",
                                          SDL_WINDOWPOS_UNDEFINED,
                                          SDL_WINDOWPOS_UNDEFINED,
                                          640, 480,
                                          SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
    if (window == NULL)
    {
        printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    // Create a renderer
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (renderer == NULL)
    {
        printf("Renderer could not be created! SDL_Error: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    // Main loop flag
    int quit = 0;

    // Event handler
    SDL_Event e;

    // While application is running
    while (!quit)
    {
        // Handle events on queue
        while (SDL_PollEvent(&e) != 0)
        {
            // User requests quit
            if (e.type == SDL_QUIT)
            {
                quit = 1;
            }

            // User presses a key
            else if (e.type == SDL_KEYDOWN)
            {
                switch (e.key.keysym.sym)
                {
                case SDLK_ESCAPE:
                    quit = 1;
                    break;
                }
            }

        } // End SDL_PollEvent loop

        //--------------------------------------------

        // Clear screen

        // Set draw color to light gray
        SDL_SetRenderDrawColor(renderer, 0xCC, 0xCC, 0xCC, SDL_ALPHA_OPAQUE);

        // Clear the screen
        SDL_RenderClear(renderer);

        //--------------------------------------------

        /*

        // Create a rectangle
        SDL_Rect fillRect = {200, 150, 240, 180};

        // Draw the rectangle 1
        drawRectangle(renderer, &fillRect, (SDL_Color){0xFF, 0x00, 0x00, 0xFF});

        // Draw the rectangle 2

        // - modify the rectangle position
        fillRect.x = 120;
        fillRect.y = 120;

        // - draw the rectangle
        drawRectangle(renderer, &fillRect, (SDL_Color){0xFF, 0xFF, 0x00, 0xFF});

        //--------------------------------------------

        // Draw the triangle 1
        Point2d A = {100, 100}, B = {100, 110}, C = {110, 100};

        //--------------------------------------------

        // Draw the triangle 1
        drawTrianglePixels(renderer, A, B, C, (SDL_Color){0x00, 0xFF, 0x00, 0xFF});
        drawTriangleLines(renderer, A, B, C, (SDL_Color){0x00, 0x00, 0x00, 0xFF});

        //--------------------------------------------

        // Draw the triangle 2

        // - modify the triangle position
        randomTriangle(&A, &B, &C);

        // - draw the triangle
        drawTrianglePixels(renderer, A, B, C, (SDL_Color){0x00, 0xFF, 0x00, 0xFF});
        drawTriangleLines(renderer, A, B, C, (SDL_Color){0x00, 0x00, 0x00, 0xFF});

        */

        //--------------------------------------------

        /*

        // Set draw color to light gray
        SDL_SetRenderDrawColor(renderer, 0xCC, 0x00, 0x00, SDL_ALPHA_OPAQUE);

        // - draw the point
        SDL_RenderDrawPoint(renderer, 10, 15);

        for (int px = 20; px <= 50; px++)
            for (int py = 30; py <= 60; py++)
                SDL_RenderDrawPoint(renderer, px, py);

        */

        //--------------------------------------------

        // call function Draw()
        lua_getglobal(L, "Draw");
        if (lua_isfunction(L, -1))
        {
            if (lua_pcall(L, 0, 1, 0) == LUA_OK)
            {
                lua_pop(L, lua_gettop(L));
            }
        }

        //--------------------------------------------

        // - update the screen
        // - repeat
        // - until the user closes the window
        // - or presses the ESC key

        // Update screen
        SDL_RenderPresent(renderer);
    } // loop

    lua_close(L);

    // Destroy renderer and window
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);

    // Quit SDL subsystems
    SDL_Quit();

    return 0;
}