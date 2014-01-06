module play.core.input;

import std.container;
import std.stdio;
import derelict.sdl2.sdl;
import play.core.engine : Game;
import play.core.geo : Vector2D;
import std.range : walkLength;

alias DList!(SDL_Joystick*) JoystickList;

class VectorPair {
    this(Vector2D one, Vector2D two) {
        this.one = one;
        this.two = two;
    }

    Vector2D one;
    Vector2D two;
}

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
            if (event.type == SDL_QUIT) {
                Game.Instance.quit();
            }

            if (event.type == SDL_JOYAXISMOTION) {
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
    }

    Array!VectorPair m_joystickValues;
    bool m_bJoysticksInitialized;
    JoystickList m_joysticks;
    static InputHandler s_instance;
    int m_joystickDeadZone = 10000;

}
