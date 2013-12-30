import std.stdio;
import derelict.opengl3.gl;
import derelict.glfw3.glfw3;

void main()
{
	DerelictGL.load();
    DerelictGLFW3.load();

    if (!glfwInit()) throw new Exception("Failed to initialize GLFW");

    GLFWwindow* window = glfwCreateWindow(800, 600, "AWW YEAH 011.derelict", null, null);
    if (!window) throw new Exception("Uh oh. No window.");


    glfwMakeContextCurrent(window);


    while (!glfwWindowShouldClose(window))
    {
        float ratio;
        int width, height;
        glfwGetFramebufferSize(window, &width, &height);
        ratio = width / cast(float)height;
        glViewport(0, 0, width, height);
        glClear(GL_COLOR_BUFFER_BIT);
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(-ratio, ratio, -1.0f, 1.0f, 1.0f, -1.0f);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glRotatef(cast(float)glfwGetTime() * 50.0f, 0.0f, 0.0f, 1.0f);
        glBegin(GL_TRIANGLES);
        glColor3f(1.0f, 0.0f, 0.0f);
        glVertex3f(-0.6f, -0.4f, 0.0f);
        glColor3f(0.0f, 1.0f, 0.0f);
        glVertex3f(0.6f, -0.4f, 0.0f);
        glColor3f(0.0f, 0.0f, 1.0f);
        glVertex3f(0.0f, 0.6f, 0.0f);
        glEnd();
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwDestroyWindow(window);
    glfwTerminate();

}
