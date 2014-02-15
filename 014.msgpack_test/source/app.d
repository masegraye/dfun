import stdio = std.stdio;
import std.file;
import msgpack;

struct S { int x; float y; string z; }

void main()
{ 
    S input = S(10, 25.5, "message");
    ubyte[] inData = pack(input);

    write("file.dat", inData);

    ubyte[] outData = cast(ubyte[])read("file.dat");

    S target = unpack!(S, false)(outData);

    assert(target.x == input.x);
    assert(target.y == input.y);
assert(target.z == input.z);

}
