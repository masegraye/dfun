import std.file;
import std.stdio : writeln;
import derelict.lua.lua;

void main()
{
    DerelictLua.load();

    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    int x;
    int y;

    auto filename = cast(const(char)*)"public/test.lua";

    if (luaL_loadfile(L, filename) || lua_pcall(L, 0, 0, 0)) {
        throw new Exception("Cannot load config file!");
    }

    lua_getglobal(L, "my_x");
    lua_getglobal(L, "my_y");

    if (!lua_isnumber(L, -2)) {
        throw new Exception("my_x should be a number");
    }

    if (!lua_isnumber(L, -1)) {
        throw new Exception("my_y should be a number");
    }

    x = cast(int)lua_tonumber(L, -2);
    y = cast(int)lua_tonumber(L, -1);

    writeln("X, Y: ", x, ", ", y);

    lua_close(L);
}
