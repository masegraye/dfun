import std.stdio;
import std.math;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import play.d;
import demo;


shared static this() {
    DerelictSDL2.load();
    DerelictSDL2Image.load();
}

const(int) FPS = 60;
const(int) DELAY_TIME = cast(int)(1000.0f / FPS);

int main()
{
    uint frameStart, frameTime;

    if (!Game.Instance().initialize("WOO!", 100, 100, 640, 480)) {
        return 1;
    }


    TextureManager.Instance.load("public/assets/claudius.png", "claudius", Game.Instance.renderer);
    Game.Instance.addGameObject(new Player(LoaderParams(100, 100, 32, 60, "claudius")));

    while(Game.Instance().running) {
        frameStart = SDL_GetTicks();

        Game.Instance().handleEvents();
        Game.Instance().update();
        Game.Instance().render();

        frameTime = SDL_GetTicks() - frameStart;
        if (frameTime < DELAY_TIME) {
            SDL_Delay(cast(int)(DELAY_TIME - frameTime));
        }
    }
    Game.Instance().clean();
    return 0;
}

