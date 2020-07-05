#pragma once

// glad must come before glfw3
#include <glad/glad.h>

#include <GLFW/glfw3.h>

#include <glm/gtc/matrix_transform.hpp>

#include <functional>
#include <iostream>

// this plumbing is necessary because
// a lambda that captures can't be used as a function ptr
using KeyCallback = std::function<void(int, int, int, int)>;
inline static KeyCallback _RenderWindow_keyCallback;
inline static void _RenderWindow_keyCallbackWrapper(GLFWwindow* window, int k, int s, int a, int m) {
  _RenderWindow_keyCallback(k, s, a, m);
}

using CharCallback = std::function<void(unsigned int)>;
inline static CharCallback _RenderWindow_charCallback;
inline static void _RenderWindow_charCallbackWrapper(GLFWwindow* window, unsigned int codepoint) {
  _RenderWindow_charCallback(codepoint);
}

using MouseCallback = std::function<void(int, int, int)>;
inline static MouseCallback _RenderWindow_mouseCallback;
inline static void _RenderWindow_mouseCallbackWrapper(GLFWwindow* window, int b, int a, int m) {
  _RenderWindow_mouseCallback(b, a, m);
}

using CursorCallback = std::function<void(double, double)>;
inline static CursorCallback _RenderWindow_cursorCallback;
inline static void _RenderWindow_cursorCallbackWrapper(GLFWwindow* window, double x, double y) {
  _RenderWindow_cursorCallback(x, y);
}

using ScrollCallback = std::function<void(double, double)>;
inline static ScrollCallback _RenderWindow_scrollCallback;
inline static void _RenderWindow_scrollCallbackWrapper(GLFWwindow* window, double x, double y) {
  _RenderWindow_scrollCallback(x, y);
}

using ResizeCallback = std::function<void(int, int)>;
inline static ResizeCallback _RenderWindow_resizeCallback;
inline static void _RenderWindow_resizeCallbackWrapper(GLFWwindow* window, int width, int height) {
  _RenderWindow_resizeCallback(width, height);
}

class RenderWindow {
  GLFWwindow* _window;

public:
  int _width;
  int _height;

  /// windowed mode
  RenderWindow(const char* name, int width, int height) : _width(width), _height(height) {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 6);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    _window = glfwCreateWindow(_width, _height, name, NULL, NULL);
    if (_window == NULL) {
      std::cout << "Failed to create GLFW window" << std::endl;
      glfwTerminate();
      exit(-1);
    }
    glfwMakeContextCurrent(_window);

    // load opengl
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
      std::cout << "Failed to initialize GLAD" << std::endl;
      glfwTerminate();
      exit(-1);
    }
    setResizeCallback([&](int width, int height) {
      _width = width;
      _height = height;
      glViewport(0, 0, _width, _height);
    });
    glViewport(0, 0, _width, _height);
  }

  /// fullscreen mode
  RenderWindow(const char* name) {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 6);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    auto* monitor = glfwGetPrimaryMonitor();
    auto* vm = glfwGetVideoMode(monitor);
    _width = vm->width;
    _height = vm->height;

    _window = glfwCreateWindow(_width, _height, name, monitor, NULL);
    if (_window == NULL) {
      std::cout << "Failed to create GLFW window" << std::endl;
      glfwTerminate();
      exit(-1);
    }
    glfwMakeContextCurrent(_window);

    // load opengl
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
      std::cout << "Failed to initialize GLAD" << std::endl;
      glfwTerminate();
      exit(-1);
    }
    setResizeCallback([&](int width, int height) {
      _width = width;
      _height = height;
      glViewport(0, 0, _width, _height);
    });
    glViewport(0, 0, _width, _height);
  }

  ~RenderWindow() {
    glfwTerminate();
  }

  // clang-format off
  GLFWwindow* window() { return _window; }
  int height() const   { return _height; }
  int width() const    { return _width;  }
  float aspectRatio() const { return (float)(_width) / (float)(_height); }

  bool isOpen() const { return not glfwWindowShouldClose(_window); }
  void swapBuffers()  { glfwSwapBuffers(_window); }
  void close()        { glfwSetWindowShouldClose(_window, true); }

  float widthScalingFactor() const { return 1.f * _width / _height; }
  // clang-format on

  /////////////////// Callbacks and Input ///////////////

  // returns true if the key is pressed
  bool getKey(int key_code) {
    return glfwGetKey(_window, key_code) == GLFW_PRESS;
  }

  void setMousePos(double x, double y) {
    glfwSetCursorPos(_window, x, y);
  }

  void setInputMode(int mode, int value) {
    glfwSetInputMode(_window, mode, value);
  }

  glm::vec2 mousePos() {
    // NOTE: this mouse position is "relative to the client area of the window"
    // according to glfw
    double xpos, ypos;
    glfwGetCursorPos(_window, &xpos, &ypos);
    return glm::vec2(xpos, ypos);
  }

  void setKeyCallback(KeyCallback keyCallback) {
    _RenderWindow_keyCallback = keyCallback;
    glfwSetKeyCallback(_window, _RenderWindow_keyCallbackWrapper);
  }
  void setCharCallback(CharCallback charCallback) {
    _RenderWindow_charCallback = charCallback;
    glfwSetCharCallback(_window, _RenderWindow_charCallbackWrapper);
  }
  void setMouseCallback(MouseCallback mouseCallback) {
    _RenderWindow_mouseCallback = mouseCallback;
    glfwSetMouseButtonCallback(_window, _RenderWindow_mouseCallbackWrapper);
  }
  void setCursorCallback(CursorCallback cursorCallback) {
    _RenderWindow_cursorCallback = cursorCallback;
    glfwSetCursorPosCallback(_window, _RenderWindow_cursorCallbackWrapper);
  }
  void setScrollCallback(ScrollCallback scrollCallback) {
    _RenderWindow_scrollCallback = scrollCallback;
    glfwSetScrollCallback(_window, _RenderWindow_scrollCallbackWrapper);
  }
  void setResizeCallback(ResizeCallback resizeCallback) {
    _RenderWindow_resizeCallback = resizeCallback;
    glfwSetFramebufferSizeCallback(_window, _RenderWindow_resizeCallbackWrapper);
  }
};
