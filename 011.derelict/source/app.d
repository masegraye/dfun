import std.stdio;
import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;

void main()
{
	DerelictGL3.load();
    DerelictGLFW3.load();

    if (!glfwInit()) throw new Exception("Failed to initialize GLFW");

    GLFWwindow* window = glfwCreateWindow(800, 600, "AWW YEAH 011.derelict", null, null);
    if (!window) throw new Exception("Uh oh. No window.");

    while (!glfwWindowShouldClose(window))
    {
        glfwPollEvents();
    }

    glfwTerminate();
}
