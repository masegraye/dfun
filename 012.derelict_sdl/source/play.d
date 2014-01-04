import derelict.sdl2.sdl;
import derelict.sdl2.image;
import std.container;

shared static this() {
    DerelictSDL2.load();
    DerelictSDL2Image.load();
}

class TextureManager {
    private this() {};

    @property
    static TextureManager Instance() {
        if (s_instance is null) {
            s_instance = new TextureManager();
        }
        return s_instance;
    }

    bool load(string fileName, string id, SDL_Renderer* pRenderer) {

        SDL_Surface* pTempSurface = IMG_Load("./public/assets/claudius.png");

        SDL_Texture* pTexture = SDL_CreateTextureFromSurface(pRenderer, pTempSurface);

        SDL_FreeSurface(pTempSurface);

        if (pTexture) {
            m_textureMap[id] = pTexture;
            return true;
        }

        return false;
    }

    void draw(string id,
        int x, int y,
        int width, int height,
        SDL_Renderer* pRenderer,
        SDL_RendererFlip flip = SDL_FLIP_NONE) {

        SDL_Rect srcRect;
        SDL_Rect destRect;

        srcRect.x = srcRect.y = 0;
        srcRect.w = destRect.w = width;
        srcRect.h = destRect.h = height;
        destRect.x = x;
        destRect.y = y;

        SDL_RenderCopyEx(pRenderer, m_textureMap[id],
            &srcRect, &destRect,
            0.0, cast(SDL_Point*)0,
            flip);
    }

    void drawFrame(string id,
        int x, int y,
        int width, int height,
        int currentRow, int currentFrame,
        SDL_Renderer* pRenderer,
        SDL_RendererFlip flip = SDL_FLIP_NONE) {

        SDL_Rect srcRect;
        SDL_Rect destRect;

        srcRect.x = width * currentFrame;
        srcRect.y = height * (currentRow - 1);
        srcRect.w = destRect.w = width;
        srcRect.h = destRect.h = height;

        destRect.x = x;
        destRect.y = y;

        SDL_RenderCopyEx(pRenderer, m_textureMap[id],
            &srcRect, &destRect,
            0.0, cast(SDL_Point*) 0,
            flip);

    }

private:
    static TextureManager s_instance;
    SDL_Texture*[string] m_textureMap;
}



class Game {

    private this() {}

    @property
    static Game Instance() {
        if (s_instance is null) {
            s_instance = new Game();
        }
        return s_instance;
    }

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

        TextureManager.Instance.load("public/assets/claudius.png", "claudius", m_pRenderer);

        m_gameObjects.insertBack(new Player(LoaderParams(100, 100, 32, 60, "claudius")));

        m_bRunning = true;
        return true;
    }

    void render() {
        // set to black
        //SDL_SetRenderDrawColor(m_pRenderer, 0, 0, 0, 255);

        // clear the window to black
        SDL_RenderClear(m_pRenderer);

        //TextureManager.Instance().draw("claudius", 0, 0, 32, 60, m_pRenderer);

        //TextureManager.Instance().drawFrame("claudius", 120, 240, 32, 60, 1, m_currentFrame, m_pRenderer);

        foreach(GameObject obj ; m_gameObjects) {
            obj.draw();
        }


        // Show the window
        SDL_RenderPresent(m_pRenderer);
    }

    void update() {
        m_currentFrame = cast(int)((SDL_GetTicks() / 100) % 6);

        foreach(GameObject obj ; m_gameObjects) {
            obj.update();
        }

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

    @property
    SDL_Renderer* renderer() {
        return m_pRenderer;
    }

private:
    static Game s_instance;

    bool m_bRunning;
    int m_currentFrame;
    SDL_Window* m_pWindow;
    SDL_Renderer* m_pRenderer;

    DList!GameObject m_gameObjects;
}


class Player : SDLGameObject {
    this(LoaderParams params) {
        super(params);
    }

    override void update() {
        m_x -= 1;
        m_currentFrame = cast(int)((SDL_GetTicks() / 100) % 6);
    }

    override void clean() {}
}

class SDLGameObject : GameObject {
    this(LoaderParams params) {
        super(params);
        m_x = params.x;
        m_y = params.y;
        m_width = params.width;
        m_height = params.height;
        m_textureID = params.textureID;

        m_currentRow = 1;
        m_currentFrame = 1;
    }

    override void draw() {
        TextureManager.Instance.drawFrame(m_textureID,
            m_x, m_y, m_width,
            m_height,
            m_currentRow, m_currentFrame,
            Game.Instance.renderer);
    }

protected:
    int m_x;
    int m_y;
    int m_width;
    int m_height;
    int m_currentRow;
    int m_currentFrame;
    string m_textureID;
}









abstract class GameObject {
    abstract void draw();
    abstract void update();
    abstract void clean();
protected:
    this(LoaderParams params) {}

}

struct LoaderParams {
    int x;
    int y;
    int width;
    int height;
    string textureID;
}
