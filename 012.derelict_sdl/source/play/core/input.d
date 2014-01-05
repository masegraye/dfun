module play.core.input;

import derelict.sdl2.sdl;

class InputHandler {

    @property
    static InputHandler Instance() {
        if (s_instance is null) {
            s_instance = new InputHandler();
        }
        return s_instance;
    }

    void update() {}

    void clean() {}

private:
    this(){}
    static InputHandler s_instance;
}
