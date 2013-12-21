import std.stdio;
import engine;
import lifecycle;


void main()
{

    auto appContext = new DefaultContext();
    auto appConfig = new UniverseConfig();
    auto universe = new Universe(appContext, appConfig);

    universe.start();
}
