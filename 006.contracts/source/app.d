import std.stdio;
import std.random;
import std.exception;

int test1(int x)
in {
    assert(x >= 0);
}
out(result) {
    assert(result >= 0);
}
body {
    return x + 1;
}

unittest {
    test1(1);
    bool caught = false;
    try {
        test1(-1);
    } catch(core.exception.AssertError e) {
        assert(e);
        caught = true;
    } finally {
        assert(caught);
    }
}

class Test {
    int one, five, ten;
    invariant() {
        assert(one >= 1);
        assert(five >= 5);
        assert(ten >= 10);
    }
    this() {
        one = 1;
        five = 5;
        ten = 10;
    }

    void testOne(int v) {
        one = v;
    }

}

unittest {
    auto t = new Test;
    bool caught = false;
    try {
        t.testOne(-1);
    } catch(core.exception.AssertError e) {
        assert(e);
        caught = true;
    } finally {
        assert(caught);
    }
}

void main() {
    // blatantly abusing `enforce' so I can test in release
    auto caught = false;
    try {
        enforce(0);
    } catch(Exception e) {
        enforce(e);
        caught = true;
    } finally {
        enforce(caught);
    }
}
