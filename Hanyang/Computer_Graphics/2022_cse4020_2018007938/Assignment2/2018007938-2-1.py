#!/usr/bin/env python
# -*- coding: utf-8 -*-

import glfw
from OpenGL.GL import *
import numpy as np
import math

primitive_type = GL_LINE_LOOP

def render_input(x):
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glBegin(x)
    vertex = np.linspace(0, 11, 12)
    for i in range(12):
        glVertex2fv(np.array([1.0 * np.cos(vertex[i]*math.pi/6), 1.0 * np.sin(vertex[i]*math.pi/6)]))
    glEnd()

def key_callback(window, key, scancode, action, mods):
    global primitive_type
    if key==glfw.KEY_1:
        primitive_type = GL_POINTS
    elif key==glfw.KEY_2:
        primitive_type = GL_LINES
    elif key==glfw.KEY_3:
        primitive_type = GL_LINE_STRIP
    elif key==glfw.KEY_4:
        primitive_type = GL_LINE_LOOP
    elif key==glfw.KEY_5:
        primitive_type = GL_TRIANGLES
    elif key==glfw.KEY_6:
        primitive_type = GL_TRIANGLE_STRIP
    elif key==glfw.KEY_7:
        primitive_type = GL_TRIANGLE_FAN
    elif key==glfw.KEY_8:
        primitive_type = GL_QUADS
    elif key==glfw.KEY_9:
        primitive_type = GL_QUAD_STRIP
    elif key==glfw.KEY_0:
        primitive_type = GL_POLYGON

def main():
    # Initialize the library
    if not glfw.init():
        return
    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(480, 480, "2018007938-2-1", None, None)
    if not window:
        glfw.terminate()
        return

    glfw.set_key_callback(window, key_callback)
    # Make the window's context current
    glfw.make_context_current(window)

    # Loop until the user closes the window
    while not glfw.window_should_close(window):
        # Render here, e.g. using pyOpenGL
        render_input(primitive_type)

        # Swap front and back buffers
        glfw.swap_buffers(window)

        # Poll for and process events
        glfw.poll_events()
        
    glfw.terminate()

if __name__ == "__main__":
    main()