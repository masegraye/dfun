@safe

import utils;
import lifecycle;

interface IUniverseConfig : IAppConfig {}

class UniverseConfig : IUniverseConfig {};

class Universe : App!IUniverseConfig {

    this(IAppContext context, IUniverseConfig config) {
        super(context, config);
    }

    override
    void on() {}

    override
    void off() {}
}
