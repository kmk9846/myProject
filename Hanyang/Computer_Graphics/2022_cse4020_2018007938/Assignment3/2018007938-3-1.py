#!/usr/bin/env python
# -*- coding: utf-8 -*-

import gc
import glfw
from OpenGL.GL import *
import numpy as np
import math

gComposedM = np.identity(3)

def render(T):
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()
    # draw cooridnate
    glBegin(GL_LINES)
    glColor3ub(255, 0, 0)
    glVertex2fv(np.array([0.,0.]))
    glVertex2fv(np.array([1.,0.]))
    glColor3ub(0, 255, 0)
    glVertex2fv(np.array([0.,0.]))
    glVertex2fv(np.array([0.,1.]))
    glEnd()
    # draw triangle
    glBegin(GL_TRIANGLES)
    glColor3ub(255, 255, 255)
    glVertex2fv((T @ np.array([.0,.5,1.]))[:-1])
    glVertex2fv((T @ np.array([.0,.0,1.]))[:-1])
    glVertex2fv((T @ np.array([.5,.0,1.]))[:-1])
    glEnd()


def key_callback(window, key, scancode, action, mods):
    global gComposedM
    T = np.identity(3)
    if action==glfw.PRESS or action==glfw.REPEAT:
        if key==glfw.KEY_Q:
            T[:2, 2] = [-0.1, 0.0]
            gComposedM = T@gComposedM
        elif key==glfw.KEY_E:
            T[:2, 2] = [0.1, 0.0]
            gComposedM = T@gComposedM
        elif key==glfw.KEY_A:
            T[:2, :2] = [[np.cos(np.radians(10)), -np.sin(np.radians(10))], [np.sin(np.radians(10)), np.cos(np.radians(10))]]
            gComposedM = gComposedM@T
        elif key==glfw.KEY_D:
            T[:2, :2] = [[np.cos(np.radians(-10)), -np.sin(np.radians(-10))], [np.sin(np.radians(-10)), np.cos(np.radians(-10))]]
            gComposedM = gComposedM@T
        elif key==glfw.KEY_1:
            gComposedM = np.identity(3)
        elif key==glfw.KEY_W:
            T[:2, :2] = [[0.9, 0.0], [0.0, 1.0]]
            gComposedM = T@gComposedM
        elif key==glfw.KEY_S:
            T[:2, :2] = [[np.cos(np.radians(10)), -np.sin(np.radians(10))], [np.sin(np.radians(10)), np.cos(np.radians(10))]]
            gComposedM = T@gComposedM

def main():
    # Initialize the library
    if not glfw.init():
        return
    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(480, 480, "2018007938-3-1", None, None)
    if not window:
        glfw.terminate()
        return

    glfw.set_key_callback(window, key_callback)
    # Make the window's context current
    glfw.make_context_current(window)

    # Loop until the user closes the window
    while not glfw.window_should_close(window):
        # Render here, e.g. using pyOpenGL
        render(gComposedM)
        # Swap front and back buffers
        glfw.swap_buffers(window)

        # Poll for and process events
        glfw.poll_events()
        
    glfw.terminate()

if __name__ == "__main__":
    main()