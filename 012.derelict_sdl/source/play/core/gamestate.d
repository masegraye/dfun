module play.core.gamestate;


interface IGameState {
    void update();
    void render();
    void onEnter();
    void onExit();

    @property
    const string stateID();
}


