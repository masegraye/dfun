import std.stdio;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

Game game;

int main()
{
    DerelictSDL2.load();
    DerelictSDL2Image.load();

    game = new Game();
    if (!game.initialize("Chapter 1", 100, 100, 640, 480)) {
        return 1;
    }

    while(game.running) {
        game.handleEvents();
        game.update();
        game.render();
    }
    game.clean();
    return 0;
}


class Game {
    this() {}
    ~this() {}

    bool initialize(const char* title, int xpos, int ypos, int height, int width, bool fullscreen = false) {
        if (SDL_Init(SDL_INIT_EVERYTHING) >= 0) {
            // create window
            m_pWindow = SDL_CreateWindow(title, xpos, ypos, height, width, (fullscreen ? SDL_WINDOW_FULLSCREEN : 0));
            if (m_pWindow) {
                // create renderer
                m_pRenderer = SDL_CreateRenderer(m_pWindow, -1, 0);
            } else {
                return false;
            }
        } else {
            return false;
        }
        m_bRunning = true;
        return true;
    }

    void render() {
        // set to black
        // SDL_SetRenderDrawColor(m_pRenderer, 0, 0, 0, 255);
        // clear the window to black
        SDL_RenderClear(m_pRenderer);
        // Show the window
        SDL_RenderPresent(m_pRenderer);
    }

    void update() {}

    void handleEvents() {
        SDL_Event event;
        if(SDL_PollEvent(&event)) {
            switch(event.type) {
                case SDL_QUIT:
                    m_bRunning = false;
                break;
                default:
                break;
            }
        }
    }

    void clean() {
        SDL_DestroyWindow(m_pWindow);
        SDL_DestroyRenderer(m_pRenderer);
        SDL_Quit();
    }

    @property
    bool running() {
        return m_bRunning;
    }

private:
    bool m_bRunning;
    SDL_Window* m_pWindow;
    SDL_Renderer* m_pRenderer;

}


