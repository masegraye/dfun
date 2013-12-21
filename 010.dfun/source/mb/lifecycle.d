import std.stdio;
import std.traits;

interface IAppContext {}

interface IAppConfig {}

interface IApp(T) {
public:
    void start();
    void stop();

    @property
    T configuration();

    @property
    IAppContext context();
}

abstract class App(T) : IApp!T {

    this(IAppContext, T)(IAppContext ctx, T config) if (isAssignable!(IAppConfig, T)) {
        this.config = config;
        this.ctx = ctx;
    }

    override
    void start() {
        on();
    }

    override
    void stop() {
        off();
    }

    @property
    override
    T configuration() {
        return cast(T)config;
    }

    @property
    override
    IAppContext context() {
        return ctx;
    }

protected:
    void on();
    void off();

private:
    IAppConfig config;
    IAppContext ctx;
}


unittest {

    class AppContext : IAppContext {}

    class TestAppConfig : IAppConfig {
        string appName() {
            return "TestApp";
        }
    }

    class TestApp : App!TestAppConfig {
        this(IAppContext context, TestAppConfig config) {
            super(context, config);
        }

        override void on() {
            // Noop
        }

        override void off() {
            // Noop
        }
    }

    auto appContext = new AppContext();
    auto appConfig = new TestAppConfig;
    auto app = new TestApp(appContext, appConfig);

    auto retrievedConfig = app.configuration;

    assert(retrievedConfig);
    assert(retrievedConfig.appName == "TestApp");

    auto retrievedContext = app.context;
    assert(retrievedContext);

}
