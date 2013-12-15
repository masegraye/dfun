import std.stdio;



class Foo {

    string realMethod() {
        return "boo";
    }

    string realProperty() {
        return "coo";
    }

}

string pseudoMethod(Foo a) {
    return "woo";
}

@property string pseudoProperty(Foo a) {
    return "doo";
}

unittest {
    auto foo = new Foo;
    assert(foo.realMethod() == "boo");
    assert(foo.pseudoMethod() == "woo");
    assert(foo.realProperty == "coo");
    assert(foo.pseudoProperty == "doo");
}

void main() {}
