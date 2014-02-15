module play.core.gamestate;

import std.container;

interface GameState {
    void update();
    void render();
    bool onEnter();
    bool onExit();

    @property
    const string stateID();
}

class GameStateMachine {

    void pushState(GameState state) {
        m_gameStates.insertBack(state);
        m_gameStates.back().onEnter();
    }

    void changeState(GameState state) {
        if (!m_gameStates.empty()) {
            if (m_gameStates.back().stateID == state.stateID) {
                return;
            }

            if (m_gameStates.back().onExit()) {
                m_gameStates.removeBack();
            }
        }

        m_gameStates.insertBack(state);
        m_gameStates.back().onEnter();
    }

    void popState() {
        if (!m_gameStates.empty()) {
            if (m_gameStates.back().onExit()) {
                m_gameStates.removeBack();
            }
        }
    }

private:
    DList!GameState m_gameStates;
}

unittest {
    class TestStateOne : GameState {
        void update() {}
        void render() {}
        bool onEnter() {
            return true;
        }
        bool onExit() {
            return true;
        }
        @property
        const string stateID() {
            return "one";
        }
    }

    auto testOne = new TestStateOne();
    auto machine = new GameStateMachine();

    machine.pushState(testOne);

}
