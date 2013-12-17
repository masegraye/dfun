mixin template MixinOne() {
    private int somePrivate;
    static private int c = 5;

    int getSomePrivate() {
        return somePrivate;
    }

    void setSomePrivate(int v) {
        somePrivate = v;
    }

    static int someStaticConstant() {
        return c;
    }
}

mixin template ParameterizedMixin(T) {
    private T somePrivate;
    T getSomePrivate() {
        return somePrivate;
    }

    void setSomePrivate(T v) {
        somePrivate = v;
    }
}
