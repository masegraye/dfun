
unittest {

    class TFactory(T) {
        T build() {
            return new T;
        }
    }

    class Bob {
        @property
        string name() {
            return "bob";
        }
    }

    class Rob {
        @property
        string name() {
            return "rob";
        }
    }


    auto bobFactory = new TFactory!Bob;
    assert(bobFactory);

    auto bob = bobFactory.build();
    assert(bob);
    assert(bob.name == "bob");

    alias TFactory!Rob RobFactory;
    auto robFactory = new RobFactory;
    assert(robFactory);

    auto rob = robFactory.build();
    assert(rob);
    assert(rob.name == "rob");

}
