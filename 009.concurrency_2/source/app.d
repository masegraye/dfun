import std.algorithm, std.concurrency, std.stdio;

void main()
{
    enum bufferSize = 1024 * 100;
    auto tid = spawn(&fileWriter);
    foreach (buffer; stdin.byChunk(bufferSize)) {
        send(tid, buffer.idup);
    }
}

void fileWriter() {
    for (bool running = true; running;) {
        receive(
            (immutable(ubyte)[] buffer) { stdout.write(buffer); },
            (OwnerTerminated _) { running = false; }
        );
    }
    stderr.writeln("Normally terminated.");
}
