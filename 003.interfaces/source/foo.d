interface Foo {
    final void foobar() {
        foo();
        bar();
    }


// NVI is currently broken!
// http://d.puremagic.com/issues/show_bug.cgi?id=4542

// This should be private, but it has to be public to compile in DMD

// private:
protected:
    void foo();
    void bar();

}
