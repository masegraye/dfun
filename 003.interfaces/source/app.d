import std.stdio;

import foo;
import parameterized;

class TheFoo : Foo {
    final override protected void foo() {};
    final override protected void bar() {};
}

unittest {
    auto f = new TheFoo();

    // NVI is currently broken. I shouldn't be able to call
    // Foo#foo or Foo#bar. Just TheFoo#foobar.
    f.foo();
    f.bar();
    f.foobar();
}

class MyStack(T) : Stack!T {
    private T[] _store;

    @property bool empty() {
        return _store.length == 0;
    }

    @property ref T top() {
        assert(!empty);
        return _store[0];
    }

    void push(T value) {
        _store ~= value;
    }

    T pop() {
        assert(!empty);
        auto last = _store[$-1];
        _store = _store[0 .. $-1];
        return last;
    }

    @property ulong length() {
        return _store.length;
    }
}

alias MyStack!string StringStack;

ref string frobble(StringStack s) {
    return s.top;
}

unittest {

    auto ts = new StringStack;

    ts.push("hello");
    ts.push("there");
    auto popped = ts.pop();
    assert("there" == popped);
    assert(ts.length == 1);
    assert("hello" == ts.top);

    popped = ts.pop();
    assert("hello" == popped);
    assert(ts.length == 0);

    ts.push("frobble");
    assert("frobble" == ts.frobble);
}

void main() {};
