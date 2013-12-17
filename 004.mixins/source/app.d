import std.stdio;

import mixins;


class A {
    mixin MixinOne;
}

unittest {
    auto a = new A;
    a.setSomePrivate(1);
    assert(1 == a.getSomePrivate());
    assert(A.someStaticConstant() == 5);
}

class B {
    mixin ParameterizedMixin!string;
}

unittest {
    auto b = new B;
    b.setSomePrivate("hello");
    assert("hello" == b.getSomePrivate());
}


void main() {}
