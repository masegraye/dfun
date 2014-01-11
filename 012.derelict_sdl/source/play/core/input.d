module play.core.input;

import std.container;
import std.stdio;
import derelict.sdl2.sdl;
import play.core.engine : Game;
import play.core.geo : Vector2D;
import std.range : walkLength;

alias DList!(SDL_Joystick*) JoystickList;

class Pair(T) {
    this(T one, T two) {
        this.one = one;
        this.two = two;
    }

    T one;
    T two;
}

enum {
    LEFT = 0,
    MIDDLE = 1,
    RIGHT = 2
}

alias Pair!Vector2D VectorPair;

class InputHandler {

    @property
    static InputHandler Instance() {
        if (s_instance is null) {
            s_instance = new InputHandler();
        }
        return s_instance;
    }

    void update() {
        SDL_Event event;
        while(SDL_PollEvent(&event)) {
            m_keystates = SDL_GetKeyboardState(null);

            switch(event.type) {
                case SDL_QUIT:
                    Game.Instance.quit();
                break;

                case SDL_JOYAXISMOTION:
                    onJoystickAxisMove(event);
                break;

                case SDL_JOYBUTTONDOWN:
                    onJoystickButtonDown(event);
                break;

                case SDL_JOYBUTTONUP:
                    onJoystickButtonUp(event);
                break;

                case SDL_MOUSEMOTION:
                    onMouseMove(event);
                break;

                case SDL_MOUSEBUTTONDOWN:
                    onMouseButtonDown(event);
                break;

                case SDL_MOUSEBUTTONUP:
                    onMouseButtonUp(event);
                break;

                case SDL_KEYDOWN:
                    onKeyDown();
                break;

                case SDL_KEYUP:
                    onKeyUp();
                break;

                default:
                break;
            }
        }
    }

    void clean() {
        foreach(SDL_Joystick* joy ; m_joysticks) {
            if (SDL_JoystickGetAttached(joy)) {
                SDL_JoystickClose(joy);
            }
        }
        m_joysticks.clear();
    }

    int xvalue(int joy, int stick) {
        if(m_joystickValues.length > 0) {
            if (stick == 1) {
                return cast(int)m_joystickValues[joy].one.x;
            } else if (stick == 2) {
                return cast(int)m_joystickValues[joy].two.x;
            }
        }
        return 0;
    }

    int yvalue(int joy, int stick) {
        if (m_joystickValues.length > 0) {
            if (stick == 1) {
                return cast(int)m_joystickValues[joy].one.y;
            } else {
                return cast(int)m_joystickValues[joy].two.y;
            }
        }
        return 0;
    }

    bool getButtonState(int joy, int buttonNumber) {
        return m_buttonStates[joy][buttonNumber];
    }

    bool getMouseButtonState(int buttonNumber) {
        return m_mouseButtonStates[buttonNumber];
    }

    ref Vector2D getMousePosition() {
        return m_mousePosition;
    }

    bool isKeyDown(SDL_Scancode key) {
        if (m_keystates) {
            if (m_keystates[key] == 1) {
                return true;
            }
        }
        return false;
    }

    void intializeJoysticks() {
        if (SDL_WasInit(SDL_INIT_JOYSTICK) == 0) {
            SDL_InitSubSystem(SDL_INIT_JOYSTICK);
        }

        if(SDL_NumJoysticks() > 0) {
            for(int i = 0; i < SDL_NumJoysticks(); i++) {
                SDL_Joystick* joy = SDL_JoystickOpen(i);
                if(joy) {
                    m_joysticks.insertBack(joy);
                    m_joystickValues.insertBack(new VectorPair(Vector2D(0,0), Vector2D(0,0)));

                    Array!bool tempButtons;
                    for (int j = 0; j < SDL_JoystickNumButtons(joy); j++) {
                        tempButtons.insertBack(false);
                    }
                    m_buttonStates.insertBack(tempButtons);

                } else {
                    writeln(stderr, "Error %s", SDL_GetError());
                }
            }
            SDL_JoystickEventState(SDL_ENABLE);
            m_bJoysticksInitialized = true;
            writeln("Initialized joysticks: ", walkLength(m_joysticks[]));
        } else {
            m_bJoysticksInitialized = false;
            writeln("No joysticks to initialize...");
        }
    }

    @property
    bool joysticksInitialized() {
        return m_bJoysticksInitialized;
    }

private:
    this(){
        m_bJoysticksInitialized = false;
        m_joysticks = JoystickList();
        for(int i = 0; i < 3; i++) {
            m_mouseButtonStates.insertBack(false);
        }
    }


    void onKeyUp() {}
    void onKeyDown() {}

    void onMouseMove(ref SDL_Event event) {
        m_mousePosition.x = event.motion.x;
        m_mousePosition.y = event.motion.y;
    }

    void onMouseButtonDown(ref SDL_Event event) {
        if (event.button.button == SDL_BUTTON_LEFT) {
            m_mouseButtonStates[LEFT] = true;
        }
        if (event.button.button == SDL_BUTTON_MIDDLE) {
            m_mouseButtonStates[MIDDLE] = true;
        }
        if (event.button.button == SDL_BUTTON_RIGHT) {
            m_mouseButtonStates[RIGHT] = true;
        }
    }

    void onMouseButtonUp(ref SDL_Event event) {
        if (event.button.button == SDL_BUTTON_LEFT) {
            m_mouseButtonStates[LEFT] = false;
        }
        if (event.button.button == SDL_BUTTON_MIDDLE) {
            m_mouseButtonStates[MIDDLE] = false;
        }
        if (event.button.button == SDL_BUTTON_RIGHT) {
            m_mouseButtonStates[RIGHT] = false;
        }
    }

    void onJoystickAxisMove(ref SDL_Event event) {
        int whichOne = event.jaxis.which;

        // left stick, left or right
        if(event.jaxis.axis == 0) {
            {
                Vector2D* vector = &(m_joystickValues[whichOne].one);
                if (event.jaxis.value > m_joystickDeadZone) {
                    m_joystickValues[whichOne].one.x = 1;
                } else if (event.jaxis.value < -m_joystickDeadZone) {
                    m_joystickValues[whichOne].one.x = -1;
                } else {
                    m_joystickValues[whichOne].one.x = 0;
                }
            }
        }


        // left stick, up or down
        if (event.jaxis.axis == 1) {
            {
                Vector2D* vector = &m_joystickValues[whichOne].one;
                if (event.jaxis.value > m_joystickDeadZone) {
                    vector.y = 1;
                } else if (event.jaxis.value < -m_joystickDeadZone) {
                    vector.y = -1;
                } else {
                    vector.y = 0;
                }
            }
        }

        // right stick, left or right
        if (event.jaxis.axis == 3) {
            {
                Vector2D* vector = &m_joystickValues[whichOne].two;
                if (event.jaxis.value > m_joystickDeadZone) {
                    vector.x = 1;
                } else if (event.jaxis.value < -m_joystickDeadZone) {
                    vector.x = -1;
                } else {
                    vector.x = 0;
                }
            }
        }

        // right stick, up down
        if (event.jaxis.axis == 4) {
            {
                Vector2D* vector = &m_joystickValues[whichOne].two;
                if (event.jaxis.value > m_joystickDeadZone) {
                    vector.y = 1;
                } else if (event.jaxis.value < -m_joystickDeadZone) {
                    vector.y = -1;
                } else {
                    vector.y = 0;
                }
            }
        }
    }

    void onJoystickButtonDown(ref SDL_Event event) {
        int whichOne = event.jaxis.which;
        m_buttonStates[whichOne][event.jbutton.button] = true;
        version(PLAY_ENABLE_DEBUG_LOGGING) {
            writeln("Button down ", event.jbutton.button);
        }
    }

    void onJoystickButtonUp(ref SDL_Event event) {
        int whichOne = event.jaxis.which;
        m_buttonStates[whichOne][event.jbutton.button] = false;
        version(PLAY_ENABLE_DEBUG_LOGGING) {
            writeln("Button up ", event.jbutton.button);
        }
    }


    Array!VectorPair m_joystickValues;
    Array!(Array!bool) m_buttonStates;
    Array!bool m_mouseButtonStates;
    Vector2D m_mousePosition;
    Uint8* m_keystates;

    bool m_bJoysticksInitialized;
    JoystickList m_joysticks;
    static InputHandler s_instance;
    int m_joystickDeadZone = 10000;


}
