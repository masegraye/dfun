import std.stdio;


class Foo {
    string bar() {
        return "baz";
    }
}

unittest {
    auto c = new Foo;
    assert(c.bar() == "baz");
}

struct Foo2 {
    uint field1;
    bool field2;
    string field3;
}

unittest {
    Foo2 foo2;
    assert(foo2.field1 == uint.init);
    assert(foo2.field2 == bool.init);
    assert(foo2.field3 == string.init);
    foo2.field1 = 123;
    foo2.field2 = true;
    foo2.field3 = "hello";
    assert(foo2.field1 == 123);
    assert(foo2.field2 == true);
    assert(foo2.field3 == "hello");

    Foo2 otherFoo = foo2;
    otherFoo.field3 = "world";
    assert(foo2.field3 != otherFoo.field3);

    Foo2* lastFoo = &otherFoo;
    (*lastFoo).field3 = "worldagain";

    assert(otherFoo.field3 == "worldagain");
}

static void main() {}
