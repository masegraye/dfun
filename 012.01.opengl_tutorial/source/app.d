import std.stdio;

import derelict.opengl3.gl;
import derelict.glfw3.glfw3;

shared static this() {
}

void main()
{
 //   DerelictGL.load();
    DerelictGL.loadClassicVersions(GLVersion.GL20);
    DerelictGLFW3.load();

    if (!glfwInit()) throw new Exception("Failed to initialize GLFW");

    GLFWwindow* window = glfwCreateWindow(800, 600, "AWW YEAH 011.derelict", null, null);
    if (!window) throw new Exception("Uh oh. No window.");

    glfwMakeContextCurrent(window);

    GLfloat[9] vertices = [
        -1.0f, -1.0f, 0.0f,
        1.0f, -1.0f, 0.0f,
        0.0f,  1.0f, 0.0f,
    ];

    GLuint vertexBuffer;

    glGenBuffers(1, &vertexBuffer);

    //glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    //glBufferData(GL_ARRAY_BUFFER, cast(long)vertices.sizeof, vertices.ptr, GL_STATIC_DRAW);

    //while (!glfwWindowShouldClose(window)) {
    //    glClear(GL_COLOR_BUFFER_BIT);

    //    glEnableVertexAttribArray(0);

    //    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    //    glVertexAttribPointer(
    //       0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
    //       3,                  // size
    //       GL_FLOAT,           // type
    //       GL_FALSE,           // normalized?
    //       0,                  // stride
    //       cast(void*) 0        // array buffer offset
    //    );

    //    glDrawArrays(GL_TRIANGLES, 0, 3); // Starting from vertex 0; 3 vertices total -> 1 triangle

    //    glDisableVertexAttribArray(0);

    //    glfwPollEvents();
    //}

    glfwDestroyWindow(window);
    glfwTerminate();


}
