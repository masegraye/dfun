interface Stack(T) {
    @property bool empty();
    @property ref T top();
    void push(T value);
    T pop();
}
