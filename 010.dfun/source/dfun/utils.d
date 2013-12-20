@safe

class StateGuardException : Exception {
    this(string msg, string state) {
        super(msg ~ ": " ~ state);
    }
}

class InvalidStateException : StateGuardException {
    this(string msg, string state) {
        super(msg, state);
    }
}

class InvalidArgumentException : StateGuardException {
    this(string msg, string state) {
        super(msg, state);
    }
}

class StateGuard {
    bool[string] states;

    this(string...)(string validStates) {
        foreach(i, state; validStates) {
            this.states[state] = false;
        }
    }

    void require(string state) {
        _checkValidState(state);
        if (!(states[state])) {
            throw new InvalidStateException("required state but not found", state);
        }
    }

    void mark(string state) {
        _checkValidState(state);
        states[state] = true;
    }

    bool isMarked(string state) {
        _checkValidState(state);
        return states[state];
    }


private:
    void _checkValidState(string state) {
        if (!(state in states)) {
            throw new InvalidArgumentException("state was provided during mark, but not StateGuard creation", state);
        }
    }

}

unittest {
    auto sg = new StateGuard("one", "two");
    assert(sg);
    assert(!sg.isMarked("one"));
    sg.mark("one");
    assert(sg.isMarked("one"));
}
