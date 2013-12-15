import std.stdio;
import vibe.d;

void handleReq(HTTPServerRequest req, HTTPServerResponse res) {
    res.writeBody("Hello, world!", "text/plain");
}

shared static this() {
    auto settings = new HTTPServerSettings;
    settings.bindAddresses = ["::"];
    settings.port = 8080;
    listenHTTP(settings, &handleReq);
}
