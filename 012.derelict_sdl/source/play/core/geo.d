module play.core.geo;

import std.math;

struct Vector2D {

    this(float x, float y) {
        m_x = x;
        m_y = y;
    }

    @property {
        float x() {
            return m_x;
        }

        void x(float anX) {
            m_x = anX;
        }
    }



    @property {
        float y() {
           return m_y;
        }

        void y(float aY) {
            m_y = aY;
        }
    }

    @property
    float length() {
        return sqrt(m_x * m_x + m_y * m_y);
    }

    /**
     * Normalizes this vectory
     */
    void normalize() {
        float len = length;
        if (len > 0) {
            this *= 1 / len;
        }
    }

    /**
     *  Addition/subtraction
     */
    Vector2D opBinary(string op)(Vector2D other) if (op == "+" || op == "-") {
        return mixin("Vector2D(m_x "~ op ~" other.m_x, m_y "~ op ~" other.m_y)");
    }

    /**
     *  In-place addition/subtraction
     */
    ref Vector2D opOpAssign(string op)(Vector2D other) if (op == "+" || op == "-") {
        mixin("m_x "~ op ~"= other.m_x; m_y "~ op ~"= other.m_y;");
        return this;
    }


    ///**
    // *  Addition
    // */
    //Vector2D opBinary(string op)(Vector2D other) if (op == "+") {
    //    return Vector2D(m_x + other.m_x, m_y + other.m_y);
    //}

    ///**
    // *  In-place addition
    // */
    //ref Vector2D opOpAssign(string op)(Vector2D other) if (op == "+") {
    //    m_x += other.m_x;
    //    m_y += other.m_y;
    //    return this;
    //}

    ///**
    // *  Subtraction
    // */
    //Vector2D opBinary(string op)(Vector2D other) if (op == "-") {
    //    return Vector2D(m_x - other.m_x, m_y - other.m_y);
    //}

    //ref Vector2D opOpAssign(string op)(Vector2D other) if (op == "-") {
    //    m_x -= other.m_x;
    //    m_y -= other.m_y;
    //    return this;
    //}

    /**
     *  Multiplication
     */
    Vector2D opBinary(string op)(float scalar) if (op == "*") {
        return Vector2D(m_x * scalar, m_y * scalar);
    }

    ref Vector2D opOpAssign(string op)(float scalar) if (op == "*") {
        m_x *= scalar;
        m_y *= scalar;
        return this;
    }


    /**
     *  Division
     */
    Vector2D opBinary(string op)(float scalar) if (op == "/") {
        return Vector2D(m_x / scalar, m_y / scalar);
    }

    ref Vector2D opOpAssign(string op)(float scalar) if (op == "/") {
        m_x /= scalar;
        m_y /= scalar;
        return this;
    }


private:
    float m_x;
    float m_y;
}

unittest {
    import std.stdio;

    auto v1 = Vector2D(1, 2);
    assert(v1.x == 1, "simple instantiation");
    assert(v1.y == 2);

    auto v2 = Vector2D(3, 4);

    auto v3 = v1 + v2;
    assert(v3.x == 4, "x is 4");
    assert(v3.y == 6, "y is 6");

    v3 += v1;

    assert(v1.x == 1, "x is still 1");
    assert(v1.y == 2, "y is still 2");

    assert(v3.x == 5, "x is 5");
    assert(v3.y == 8, "y is 7");

    auto v4 = Vector2D(2, 2);
    auto v5 = v4 * 2;
    assert(v4.x == 2);
    assert(v4.y == 2);
    assert(v5.x == 4);
    assert(v5.y == 4);

    auto v6 = v5 / 2;
    assert(v6.x == 2);
    assert(v6.y == 2);

    auto v7 = Vector2D(1, 0);
    v7.normalize();
    assert(v7.x == 1, "x is 1");
    assert(v7.y == 0, "y is 0");

}
