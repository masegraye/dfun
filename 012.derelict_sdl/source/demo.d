import play.d;
import derelict.sdl2.sdl;

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

        if (InputHandler.Instance.isKeyDown(SDL_SCANCODE_RIGHT)) {
            m_velocity.x = 2;
        } else if (InputHandler.Instance.isKeyDown(SDL_SCANCODE_LEFT)) {
            m_velocity.x = -2;
        }

        if (InputHandler.Instance.isKeyDown(SDL_SCANCODE_UP)) {
            m_velocity.y = -2;
        } else if (InputHandler.Instance.isKeyDown(SDL_SCANCODE_DOWN)) {
            m_velocity.y = 2;
        }


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

        } else {
            Vector2D vec = InputHandler.Instance.getMousePosition();
            m_velocity = (vec - m_position) / 100;
        }
        m_velocity *= m_velocityMultiplier;
    }

    int inputMult;


}
