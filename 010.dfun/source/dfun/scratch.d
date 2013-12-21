
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


    auto bobFactory = new TFactory!Bob;
    assert(bobFactory);

    auto bob = bobFactory.build();
    assert(bob);
    assert(bob.name == "bob");

}
