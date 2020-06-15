#include "Editor.hpp"
#include "RectangleProgramContext.hpp"
#include "GraphicsContext.hpp"

#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Profiler.hpp>
#include <kgfx/Str.hpp>

#include <glm/gtc/matrix_transform.hpp>

constexpr bool PROFILING = true;

int main() {
  std::cout << std::boolalpha;

  // TODO support for windowed mode and resizing
  RenderWindow window {"Kedit", 1920, 1080};
  // RenderWindow window {"kedit"};
  window.setMousePos(window.width()/2.f, window.height()/2.f);

  glfwSwapInterval(1); // framerate set: 0 for uncapped, 1 for monitor refresh rate

  Editor editor;
  editor.openBrowser();

  bool wireframe_mode = false;

  window.setKeyCallback([&](int key, int scancode, int action, int mods) {
    if ((mods & GLFW_MOD_CONTROL) && key == GLFW_KEY_W && action == GLFW_PRESS) {
      wireframe_mode = !wireframe_mode;
      if (wireframe_mode) glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      else                glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }

    editor.handleKey(key, scancode, action, mods);

    if (GLFW_PRESS == action && key == GLFW_KEY_ESCAPE) {
      window.close();
    }
  });

  struct MouseState_ {
    bool pressed = false;
    int current_button = 0;
    glm::ivec2 prev_pos = {-1, -1};
  } mouse;

  window.setMouseCallback([&](int button, int action, int mods) {
    mouse.pressed = (action == GLFW_PRESS);
    mouse.current_button = button;
    if (action == GLFW_RELEASE) {
      mouse.prev_pos = {-1, -1};
    }
  });

  window.setCursorCallback([&](double mouse_x, double mouse_y) {
  });

  // TODO smooth scrolling?
  window.setScrollCallback([&](double scroll_x, double scroll_y) {
    editor.verticalScroll(scroll_y);
  });

  GraphicsContext gc { &window };
  gc.initOptions();

  /// Load Screen ===------------------------------------------------------------------------===///
  gc.clear(0, 0, 0, 1);
  gc.text("loading", window.width()/2 - 100, window.height()/2, 1, glm::vec4(1));
  window.swapBuffers();

  gc.rectprog.init();

  /// Render Loop ===------------------------------------------------------------------------===///

  Profiler pr { 60.0 };

  while (window.isOpen()) {

    /// Update Frame Data ===----------------------------------------------------------------===///

    pr.startFrame();

    /// Development Messages ===-------------------------------------------------------------===///

    std::vector<std::string> status_messages;
    auto status = [&status_messages](std::string m) {
      status_messages.push_back(m);
    };

    /// Handle Updates ===-------------------------------------------------------------------===///
    // handle updates that need delta_time, e.g. physics, movement

    if constexpr(PROFILING) { pr.event("handle updates"); }

    editor.tick(pr.delta_time);
    
    /// Render to Screen ===-----------------------------------------------------===///
    gc.renderOptions();
    gc.alignViewport();
    gc.clear(0.5, 0.5, 0.5, 1);

    status("menu count: " + str(editor._menus.size()));
    status("buffer count: " + str(editor._buffers.size()));

    editor.render(gc);

    gc.renderRectangles();

    if (not editor._menus.empty())
      {
        status("menu selection: " + str(editor._menus.back().cursor));
      }

    if constexpr(PROFILING) { pr.event("render to screen"); }

    /// FPS Counter ===------------------------------------------------------===///

    auto tilde_width = gc.tr.textWidth("~");
    gc.text("FPS: " + str(pr.framerate), window.width() - 300 + tilde_width, 50, 1);
    gc.text("~FPS: " + str(pr.moving_avg_framerate), window.width() - 300, 80, 1);

    /// Render Messages ===--------------------------------------------------===///

    auto list_text = [&](std::vector<std::string> lines, glm::ivec2 start_pos, std::string title = "") {
      int count = 0;

      if (title != "") {
        gc.text(title, start_pos.x, start_pos.y + count++ * 30, 1);
        std::string titlebar = "";
        for (uint i = 0; i < title.length(); ++i) {
          titlebar += "-";
        }
        gc.text(titlebar, start_pos.x, start_pos.y + count++ * 30, 1);
      }

      for (std::string l : lines) {
        gc.text(l, start_pos.x, start_pos.y + count++ * 30, 1);
      }
    };

    if (not editor._menus.empty()) {
      list_text(editor.command_history, {window.width() - 500, window.height() - 700}, "history");
    }

    list_text(status_messages, {window.width() - 500, window.height() - 500}, "status");

    if constexpr(PROFILING) { pr.event("render text"); }

    pr.endFrame();

    if constexpr(PROFILING) {
      std::vector<std::string> frame_messages;
      if (not pr.fc._frames.empty()) {
        for (const Event& event : pr.fc._frames.back()._events) {
          frame_messages.emplace_back(event.name + str(": ") + str(event.elapsed_time) + "s");
        }
      }

      list_text(frame_messages, {window.width() - 500, 200}, "frames");
    }

    /// Poll Events and Swap ===------------------------------------------------------===///

    window.swapBuffers();
    glfwPollEvents();
  }
}
