#pragma once

#include "RectangleProgramContext.hpp"

struct GraphicsContext {
  /// General ===-----------------------------------------------------------------------------===///
  RenderWindow* window;
  TextRenderer tr;
  RectProgramContext rectprog;

  inline void text(std::string text, GLfloat x, GLfloat y, GLfloat scale, glm::vec4 color = glm::vec4(1))
    { tr.renderText(window->width(), window->height(), text, x, y, scale, color); };

  GraphicsContext(RenderWindow* w): window(w)
    { glViewport(0, 0, window->width(), window->height()); }

  inline void initOptions(void)
    {
      glEnable(GL_DEBUG_OUTPUT);
      glDebugMessageCallback(GLDebugMessageCallback, 0);
    };

  inline void alignViewport(void)
    { glViewport(0, 0, window->width(), window->height()); }

  inline void clear(float x, float y, float z, float w)
    { clear({x, y, z, w}); }

  inline void clear(glm::vec4 color)
    {
      glClearColor(color.x, color.y, color.z, color.w);
      glClear(GL_COLOR_BUFFER_BIT);
    }

  inline void depthClear(glm::vec4 color)
    {
      glBindFramebuffer(GL_FRAMEBUFFER, 0);
      glClearColor(color.x, color.y, color.z, color.w);
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
  
  inline void renderOptions(void)
    {
      glEnable(GL_CULL_FACE);
      glFrontFace(GL_CCW);
      glCullFace(GL_BACK);

      glEnable(GL_MULTISAMPLE);

      // NOTE: use depthClear if you use this
      // glEnable(GL_DEPTH_TEST);
      // glDepthFunc(GL_LESS);
      
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
};
