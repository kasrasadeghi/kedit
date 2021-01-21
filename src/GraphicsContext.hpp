#pragma once

#include "DebugCallback.hpp"
#include "RectangleProgramContext.hpp"

#include "backbone-core-cpp/StrView.hpp"

struct GraphicsContext {
  /// General ===-----------------------------------------------------------------------------===///
  RenderWindow* window;
  TextRenderer tr;
  RectProgramContext rectprog;
  GLfloat text_scale = 1;
  GLfloat line_height = 30;

  static constexpr bool DEBUG_SCISSOR = false;
  glm::vec2 scissor_tl;
  glm::vec2 scissor_size;

  template<int N>
  inline void text(const char (&text)[N], GLfloat x, GLfloat y, glm::vec4 color, GLfloat scale = 0)
    {
      tr.renderText(window->width(), window->height(), text, N - 1, x, y,
                    scale != 0 ? scale : text_scale, color);
    };

  inline void text(StringView text, GLfloat x, GLfloat y, glm::vec4 color, GLfloat scale = 0)
    {
      tr.renderText(window->width(), window->height(), text.data(), text.length(), x, y,
                    scale != 0 ? scale : text_scale, color);
    };

  inline void text(const std::string& text, GLfloat x, GLfloat y, glm::vec4 color, GLfloat scale = 0)
    {
      tr.renderText(window->width(), window->height(), text.data(), text.length(), x, y,
                    scale != 0 ? scale : text_scale, color);
    };

  GraphicsContext(RenderWindow* w, const std::string& binary_directory): window(w), tr(binary_directory)
    {
      glViewport(0, 0, window->width(), window->height());
      scissorFull();

    }

  inline void initOptions(void)
    {
      glEnable(GL_DEBUG_OUTPUT);
      glDebugMessageCallback(GLDebugMessageCallback, 0);
    };

  inline void alignViewport(void)
    { glViewport(0, 0, window->width(), window->height()); }

  inline void scissorFull(void)
    { scissorRect({0, 0}, {window->width(), window->height()}); }

  /// Translates top-left coordinate to lower-left coordinate.
  // glScissor uses lower left coordinates,
  //   (1, 1) is first bottom left pixel
  inline void scissorRect(glm::vec2 top_left, glm::vec2 size)
    {
      if constexpr(DEBUG_SCISSOR)
        {
          scissor_tl = top_left;
          scissor_size = size;
        }
      glScissor(top_left.x, window->height() - top_left.y - size.y,
                size.x, size.y);
    }

  inline void clear(float x, float y, float z, float w)
    { clear({x, y, z, w}); }

  inline void clear(glm::vec4 color)
    {
      glBindFramebuffer(GL_FRAMEBUFFER, 0);
      glClearColor(color.x, color.y, color.z, color.w);
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }

  // TODO: put options into RectProgramContext
  inline void renderOptions(void)
    {
      glEnable(GL_CULL_FACE);
      glFrontFace(GL_CCW);
      glCullFace(GL_BACK);

      glEnable(GL_MULTISAMPLE);

      glEnable(GL_DEPTH_TEST);
      glDepthFunc(GL_LESS);

      glEnable(GL_SCISSOR_TEST);

      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }

  inline void renderRectangles(void)
    {
      if constexpr(DEBUG_SCISSOR)
        {
          rectprog.instances.emplace_back(scissor_tl, scissor_size, glm::vec4{1, 0.1, 0.1, 0.1}, -1.f);
        }

      rectprog.render(window->width(), window->height());
      rectprog.instances.clear();
    }

  // CONSIDER: rename to "queue" or "add"
  inline void drawRectangle(glm::vec2 topleft, glm::vec2 size, glm::vec4 color, float z)
    { rectprog.instances.emplace_back(topleft, size, color, z); }
};
