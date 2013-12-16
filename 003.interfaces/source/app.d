import std.stdio;

import foo;

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

void main() {};
