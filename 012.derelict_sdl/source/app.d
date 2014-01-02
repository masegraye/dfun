import std.stdio;
import std.math;

import derelict.sdl2.sdl;

import play;

Game game;

int main()
{

    game = new Game();
    if (!game.initialize("Chapter 1", 100, 100, 640, 480)) {
        return 1;
    }

    while(game.running) {
        game.handleEvents();
        game.update();
        game.render();

        SDL_Delay(10);
    }
    game.clean();
    return 0;
}

