import std.stdio;
import std.variant;

class A {
    int opApply(int delegate(int) dg) {
        for (int i = 0; i <= 3; i++) {
            dg(i);
        }
        return 0;
    }
}

unittest {
    auto a = new A;
    auto sum = 0;
    foreach(i; a) {
        sum += i;
    }
    assert(6 == sum);
}

class B {
    int testOne() {
        return 1;
    }

    auto opDispatch(string m, Args...)(Args args) {
        if (m == "testTwo") {
            return 2;
        } else {
            return 3;
        }
    }
}

unittest {
    auto b = new B;
    assert(1 == b.testOne());
    assert(2 == b.testTwo());
    assert(3 == b.testThree());
    assert(3 == b.testFour());
}

alias Variant delegate(Dynamic self, Variant[] args) DynMethod;

class Dynamic {
    private DynMethod[string] methods;

    void addMethod(string name, DynMethod m) {
        methods[name] = m;
    }

    void removeMethod(string name) {
        methods.remove(name);
    }

    Variant call(string methodName, Variant[] args) {
        return methods[methodName](this, args);
    }

    Variant opDispatch(string m, Args...)(Args args) {
        Variant[] packedArgs = new Variant[args.length];

        foreach(i, arg; args) {
            packedArgs[i] = Variant(arg);
        }

        return call(m, packedArgs);
    }

}

unittest {
    auto obj = new Dynamic;

    obj.addMethod("testOne",
        (Dynamic, Variant[]) {
            writeln("testOne");
            return Variant(1);
    });


    assert(1 == obj.testOne());


}

void main() {}
