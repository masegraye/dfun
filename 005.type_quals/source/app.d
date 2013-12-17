import std.stdio;

struct Point {int x, y; }

unittest {

    auto origin = immutable(Point)(1, 1);
    assert(origin.x == 1);
    assert(origin.y == 1);
    static assert(is(typeof(origin.x) == immutable(int)));

    auto otherPoint = Point(1, 2);
    assert(otherPoint.y == 2);

}

// random (template-related)

template isSomeString(T) {
    enum bool isSomeString = is(T : const(char[])) || is(T : const(wchar[])) || is(T : const(dchar[]));
}

unittest {
    // random
    static assert(isSomeString!string);
    static assert(isSomeString!wstring);
    static assert(isSomeString!dstring);
    static assert(isSomeString!(char[]));
    static assert(isSomeString!(wchar[]));
    static assert(isSomeString!(dchar[]));
    static assert(!isSomeString!int);
    static assert(!isSomeString!bool);
}

class SomeClass {
    private string thing;

    this() {
        thing = "default";
    }

    this(string v) immutable {
        thing = v;
    }

    string foo() { return "foo" ~ thing; }

    immutable {
        string bar() { return "bar" ~ thing; }
    }
}

unittest {
    auto a = new SomeClass;
    assert("foodefault" == a.foo());
    auto b = new immutable(SomeClass)("baz");
    assert("barbaz" == b.bar());
}

void main() { }
