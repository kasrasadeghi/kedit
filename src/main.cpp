#include "Editor.hpp"

#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Profiler.hpp>
#include <kgfx/Str.hpp>

constexpr bool PROFILING = true;

int main() {
  srand(time(NULL));

  // RenderWindow window {"Kedit", 1920, 1080};
  RenderWindow window {"kedit"};
  window.setMousePos(window.width()/2.f, window.height()/2.f);

  glfwSwapInterval(1); // framerate set: 0 for uncapped, 1 for monitor refresh rate

  window.setKeyCallback([&](int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE) {
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

  /// GL Options ===-------------------------------------------------------------------------===///

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  glEnable(GL_MULTISAMPLE);

  /// Load Screen ===------------------------------------------------------------------------===///

  glViewport(0, 0, window.width(), window.height());
  glClearColor(0.0, 0.0, 0.0, 0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  TextRenderer tr {(float)window.width(), (float)window.height()};
  tr.renderText("loading", window.width()/2 - 100, window.height()/2, 1, glm::vec4(1));
  window.swapBuffers();

  // Set up OpenGL stuff
  // - Generate base vertices and faces
  // - Set up VAO, VBO, and uniform stuff

  /// Render Loop ===------------------------------------------------------------------------===///

  double fps_counter_time = glfwGetTime();
  int framecounter = 0;
  double moving_avg_framerate = 60.f;
  double framerate = 60.f;
  double delta_time = 0.f;

  Profiler pr;

  Editor editor;
  // editor.loadFile("README.md");
  editor.loadFile("/home/kasra/notes/projects.md");

  while (window.isOpen()) {

    if constexpr(PROFILING) { pr.startFrame(); }

    /// Update Frame Data ===----------------------------------------------------------------===///
    framecounter ++;

    constexpr int geometric_falloff_rate = 16; // try for power of 2
    delta_time = (glfwGetTime() - fps_counter_time);
    fps_counter_time = glfwGetTime();
    framerate = 1 / delta_time;
    moving_avg_framerate = ((moving_avg_framerate * (geometric_falloff_rate - 1)) + framerate) / geometric_falloff_rate;

    if constexpr(PROFILING) { pr.event("update frame data"); }

    /// Handle Updates ===-------------------------------------------------------------------===///

    // handle updates that need delta_time, e.g. physics, movement

    if constexpr(PROFILING) { pr.event("handle updates"); }

    /// Build Instances ===-------------------------------------------------------===///

    // world.build(instances);

    // glUseProgram(program_id);
    // glBindVertexArray(worldVAO);

    // glBindBuffer(GL_ARRAY_BUFFER, VBO.instances_buffer);
    // glBufferData(GL_ARRAY_BUFFER, sizeof(Instance) * instances.size(), instances.data(), GL_STATIC_DRAW);

    if constexpr(PROFILING) { pr.event("copy over instances"); }

    /// PreRender Compution ===----------------------------------------------------------------===///
    float aspect = static_cast<float>(window.width()) / window.height();
    glm::mat4 projection_matrix(0);
    glm::mat4 view_matrix(0);
    glm::mat4 light_space_matrix(0);

    // glUseProgram(program_id);
    // glEnable(GL_CULL_FACE);
		// glCullFace(GL_BACK);
    glClearColor(0.5, 0.5, 0.5, 1); // Sky color
    glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LESS);

    /// Render to Screen ===-----------------------------------------------------===///
    // GL options
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    // Clear
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glViewport(0, 0, window.width(), window.height());
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    for (Buffer& buffer : editor._buffers) {
      uint64_t line_number = 0;

      for (StringView line : buffer.contents.lines) {

        if ((50 + (30 * line_number)) > (uint64_t)(window.height())) {
          continue;
        }
        if ((50 + (30 * line_number)) < (uint64_t)(0)) {
          continue;
        }
        tr.renderText(line.stringCopy(), 200, 50 + (30 * line_number), 1);
        ++ line_number;
      }
    }

    if constexpr(PROFILING) { pr.event("render to screen"); }

    /// FPS Counter ===------------------------------------------------------===///

    auto tilde_width = tr.textWidth("~");
    tr.renderText("FPS: " + str(framerate), window.width() - 300 + tilde_width, 50, 1);
    tr.renderText("~FPS: " + str(moving_avg_framerate), window.width() - 300, 80, 1);

    /// Render Messages ===--------------------------------------------------===///
    auto list_text = [&tr](std::vector<std::string> xs, glm::ivec2 start_pos) {
      int count = 0;
      for (std::string x : xs) {
        tr.renderText(x, start_pos.x, start_pos.y + count++ * 30, 1);
      }
    };

    std::vector<std::string> status_messages {
    };

    list_text(status_messages, {100, 50});

    if constexpr(PROFILING) {
      pr.event("render text");
      pr.endFrame();

      // 2 60th's of a second is a bad frame. only keep bad frames
      if (pr._frames.back().elapsedTime() < 2/60.0) {
        pr.removeLastFrame();
      }
      std::vector<std::string> frame_messages;
      if (not pr._frames.empty()) {
        for (const Event& event : pr._frames.back()._events) {
          frame_messages.emplace_back(event.name + str(": ") + str(event.elapsed_time) + "s");
        }
      }

      list_text(frame_messages, {800, 200});
    }

    /// Poll Events and Swap ===------------------------------------------------------===///

    window.swapBuffers();
    glfwPollEvents();
  }
}
