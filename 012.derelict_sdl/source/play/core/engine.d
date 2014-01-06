module play.core.engine;

import play.core.texturemanager;
import play.core.geo;
import play.core.input : InputHandler;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import std.stdio;
import std.container;


class Game {

    private this() {}

    @property
    static Game Instance() {
        if (s_instance is null) {
            s_instance = new Game();
        }
        return s_instance;
    }

    bool initialize(const char* title,
        int xpos, int ypos,
        int height, int width,
        bool fullscreen = false) {

        if (SDL_Init(SDL_INIT_EVERYTHING) >= 0) {
            // create window
            m_pWindow = SDL_CreateWindow(title,
                xpos, ypos,
                height, width,
                (fullscreen ? SDL_WINDOW_FULLSCREEN : 0));

            if (m_pWindow) {
                // create renderer
                m_pRenderer = SDL_CreateRenderer(m_pWindow, -1, 0);
            } else {
                return false;
            }

        } else {
            return false;
        }
        InputHandler.Instance.intializeJoysticks();

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
        InputHandler.Instance.update();
    }

    void clean() {
        InputHandler.Instance.clean();
        SDL_DestroyWindow(m_pWindow);
        SDL_DestroyRenderer(m_pRenderer);
        SDL_Quit();
    }

    void quit() {
        m_bRunning = false;
    }

    @property
    bool running() {
        return m_bRunning;
    }

    @property
    const(SDL_Renderer)* renderer() {
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
        inputMult = 3;
    }

    override void update() {
        m_velocityMultiplier = 1;

        m_velocity.x = 0;
        m_velocity.y = 0;

        m_currentFrame = cast(int)((SDL_GetTicks() / 100) % 6);

        handleInput();
        super.update();
    }

    override void clean() {}

private:
    void handleInput() {
        if (InputHandler.Instance.joysticksInitialized()) {
            if (InputHandler.Instance.xvalue(0, 1) > 0 ||
                InputHandler.Instance.xvalue(0, 1) < 0) {

                m_velocity.x = (inputMult * InputHandler.Instance.xvalue(0, 1));
            }

            if (InputHandler.Instance.yvalue(0, 1) > 0 ||
                InputHandler.Instance.yvalue(0, 1) < 0) {
                m_velocity.y = (inputMult * InputHandler.Instance.yvalue(0, 1));
            }

            if (InputHandler.Instance.xvalue(0, 2) > 0 ||
                InputHandler.Instance.xvalue(0, 2) < 0) {
                m_velocity.x = (inputMult * InputHandler.Instance.xvalue(0, 2));
            }

            if (InputHandler.Instance.yvalue(0, 2) > 0 ||
                InputHandler.Instance.yvalue(0, 2) < 0) {
                m_velocity.y = (inputMult * InputHandler.Instance.yvalue(0, 2));
            }

            if (InputHandler.Instance.getButtonState(0, 14)) {
                m_velocity.x = (inputMult * 1);
            }

            if (InputHandler.Instance.getButtonState(0, 13)) {
                m_velocity.x = (inputMult * -1);
            }

            if (InputHandler.Instance.getButtonState(0, 12)) {
                m_velocity.y = (inputMult * 1);
            }

            if (InputHandler.Instance.getButtonState(0, 11)) {
                m_velocity.y = (inputMult * -1);
            }

            if (InputHandler.Instance.getButtonState(0, 2)) {
                m_velocityMultiplier = 3;
            }

            m_velocity *= m_velocityMultiplier;
        }
    }
    int inputMult;
}

class SDLGameObject : GameObject {
    this(LoaderParams params) {
        super(params);
        m_position = Vector2D(params.x, params.y);
        m_velocity = Vector2D(0, 0);
        m_acceleration = Vector2D(0, 0);

        m_width = params.width;
        m_height = params.height;
        m_textureID = params.textureID;

        m_currentRow = 1;
        m_currentFrame = 1;
    }

    override void update() {
        m_velocity += m_acceleration;
        m_position += m_velocity;
    }

    override void draw() {
        TextureManager.Instance.drawFrame(m_textureID,
            cast(int)m_position.x, cast(int)m_position.y,
            m_width, m_height,
            m_currentRow, m_currentFrame,
            Game.Instance.renderer);
    }

protected:
    Vector2D m_position;
    Vector2D m_velocity;
    Vector2D m_acceleration;

    int m_velocityMultiplier;
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
