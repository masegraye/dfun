import std.stdio;
import std.math;

import derelict.sdl2.sdl;

import play;

Game game;

int main()
{


    if (!Game.Instance().initialize("Chapter 1", 100, 100, 640, 480)) {
        return 1;
    }

    while(Game.Instance().running) {
        Game.Instance().handleEvents();
        Game.Instance().update();
        Game.Instance().render();

        SDL_Delay(10);
    }
    Game.Instance().clean();
    return 0;
}

