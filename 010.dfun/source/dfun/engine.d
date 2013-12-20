@safe

import utils;

class Universe {

    this() {
        this._guard = new StateGuard("started", "disposed");
    }

    void start() {
        synchronized(_guard) {
            _guard.mark("started");
        }
    }

private:
    StateGuard _guard;
}
