import derelict.sdl2.sdl;
import derelict.sdl2.image;

shared static this() {
    DerelictSDL2.load();
    DerelictSDL2Image.load();
}

class TextureManager {
    bool load(string fileName, string id, SDL_Renderer* pRenderer) {
        return true;
    }

    void draw(string id,
        int x, int y,
        int width, int height,
        SDL_Renderer* pRenderer,
        SDL_RendererFlip flip = SDL_FLIP_NONE) {}

    void drawFrame(string id,
        int x, int y,
        int width, int height,
        int currentRow, int currentFrame,
        SDL_Renderer* pRenderer,
        SDL_RendererFlip flip = SDL_FLIP_NONE) {}

private:
    SDL_Texture*[string] m_textureMap;
}



class Game {
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

        SDL_Surface* pTempSurface = IMG_Load("./public/assets/claudius.png");

        m_pTexture = SDL_CreateTextureFromSurface(m_pRenderer, pTempSurface);

        SDL_FreeSurface(pTempSurface);

        // SDL_QueryTexture(m_pTexture, null, null, &m_sourceRectangle.w, &m_sourceRectangle.h);

        m_sourceRectangle.w = 32;
        m_sourceRectangle.h = 60;

        m_sourceRectangle.x = 0;
        m_sourceRectangle.y = 63;

        m_destinationRectangle.x = 320;
        m_destinationRectangle.y = 240;
        m_destinationRectangle.w = m_sourceRectangle.w;
        m_destinationRectangle.h = m_sourceRectangle.h;

        m_bRunning = true;
        return true;
    }

    void render() {
        // set to black
        SDL_SetRenderDrawColor(m_pRenderer, 0, 0, 0, 255);

        // clear the window to black
        SDL_RenderClear(m_pRenderer);

        SDL_RenderCopyEx(m_pRenderer,
            m_pTexture,
            &m_sourceRectangle,
            &m_destinationRectangle,
            0.0, cast(SDL_Point*)0,
            SDL_FLIP_HORIZONTAL);

        // Show the window
        SDL_RenderPresent(m_pRenderer);
    }

    void update() {
        auto frame = cast(int)((SDL_GetTicks() / 100) % 6);
        m_sourceRectangle.x = 32 * frame;
    }

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

    SDL_Texture* m_pTexture;
    SDL_Rect m_sourceRectangle;
    SDL_Rect m_destinationRectangle;

}


