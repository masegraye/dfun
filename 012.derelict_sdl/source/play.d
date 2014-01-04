import derelict.sdl2.sdl;
import derelict.sdl2.image;
import std.container;

shared static this() {
    DerelictSDL2.load();
    DerelictSDL2Image.load();
}

class TextureManager {
    private this() {};

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

        TextureManager.Instance().load("public/assets/claudius.png", "claudius", m_pRenderer);

        Player player = new Player();
        player.load(320, 240, 32, 60, "claudius");

        Enemy enemy = new Enemy();
        enemy.load(420, 240, 32, 60, "claudius");

        m_gameObjects.insertBack(player);
        m_gameObjects.insertBack(enemy);

        m_bRunning = true;
        return true;
    }

    void render() {
        // set to black
        //SDL_SetRenderDrawColor(m_pRenderer, 0, 0, 0, 255);

        // clear the window to black
        SDL_RenderClear(m_pRenderer);

        TextureManager.Instance().draw("claudius", 0, 0, 32, 60, m_pRenderer);

        TextureManager.Instance().drawFrame("claudius", 120, 240, 32, 60, 1, m_currentFrame, m_pRenderer);

        foreach(GameObject obj ; m_gameObjects) {
            obj.draw(m_pRenderer);
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

private:
    bool m_bRunning;
    int m_currentFrame;
    SDL_Window* m_pWindow;
    SDL_Renderer* m_pRenderer;

    DList!GameObject m_gameObjects;
}

class Player : GameObject {


    override void load(int x, int y,
        int width, int height,
        string textureID) {

        super.load(x, y, width, height, textureID);
    }

    override void draw(SDL_Renderer* pRenderer) {
        super.draw(pRenderer);
    }

    override void update() {
        m_x -= 1;
        m_currentFrame = cast(int)((SDL_GetTicks() / 100) % 6);
    }

    override void clean() {
        super.clean();
    }
}

class Enemy : GameObject {
    override void load(int x, int y, int width, int height, string textureID) {
        super.load(x, y, width, height, textureID);
    }
    override void draw(SDL_Renderer* pRenderer) {
        super.draw(pRenderer);
    }
    override void update() {
        m_x += 1;
        m_y += 1;
        m_currentFrame = cast(int)((SDL_GetTicks() / 100) % 6);
    }
    override void clean() {
        super.clean();
    }

}

class GameObject {

    void load(int x, int y,
        int width, int height,
        string textureID) {

        m_textureID = textureID;

        m_x = x;
        m_y = y;

        m_width = width;
        m_height = height;

        m_currentRow = 1;
        m_currentFrame = 1;
    }

    void draw(SDL_Renderer* pRenderer) {
        TextureManager.Instance().drawFrame(
            m_textureID,
            m_x, m_y,
            m_width, m_height,
            m_currentRow, m_currentFrame,
            pRenderer);
    }

    void update() {
        m_x += 1;
    }

    void clean() {

    }

protected:
    string m_textureID;

    int m_currentFrame;
    int m_currentRow;

    int m_x;
    int m_y;

    int m_width;
    int m_height;

}
