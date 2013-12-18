import std.stdio;
import std.random;


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

unittest {}

void main() {
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
