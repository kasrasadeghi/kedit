#include "Editor.hpp"
#include "DebugCallback.hpp"
#include "Shaders.hpp"

#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Profiler.hpp>
#include <kgfx/Str.hpp>

#include <glm/gtc/matrix_transform.hpp>

constexpr bool PROFILING = true;

int main() {
  srand(time(NULL));

  // RenderWindow window {"Kedit", 1920, 1080};
  RenderWindow window {"kedit"};
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

  // TODO smooth scrolling?
  window.setScrollCallback([&](double scroll_x, double scroll_y) {
    editor.verticalScroll(scroll_y);
  });

  /// GL Options ===-------------------------------------------------------------------------===///


  glEnable(GL_DEBUG_OUTPUT);
  glDebugMessageCallback(GLDebugMessageCallback, 0);

  // glEnable(GL_DEPTH_TEST);
  // glDepthFunc(GL_LESS);

  // glEnable(GL_CULL_FACE);
  // glCullFace(GL_BACK);

  glDisable(GL_CULL_FACE);
  glFrontFace(GL_CCW);

  // glEnable(GL_BLEND);
  // glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

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

  /// Rectangle Shader Setup
  // create vertices and indices
  // - indices are for elements array, lets you reuse vertices

/*
 *  A  D        0
 *  |\   order: |\   so it's clockwise
 *  | \         | \
 *  B--C        2--1
 */
  std::vector<glm::vec2> corner_vertices;
  corner_vertices.emplace_back(0,  0); // 0
  corner_vertices.emplace_back(0, -1); // 2
  corner_vertices.emplace_back(1, -1); // 1

  std::vector<glm::uvec3> corner_indices;
  corner_indices.emplace_back(0, 1, 2);

  struct Instance {
    Instance(glm::vec2 p, glm::vec2 dim):
      tlx(p.x), tly(p.y), dx(dim.x), dy(dim.y) {}
    float tlx;
    float tly;

    float dx;
    float dy;
  } __attribute__((packed));

  std::vector<Instance> instances;
  instances.emplace_back(glm::vec2{-.9, -.9}, glm::vec2{1.8, 1.8});

  // TODO fix background positioning using projection matrix @ref1
  // instances.emplace_back(glm::vec2{1000, 1000}, glm::vec2{100, 100});

  // set up VAO, VBO, and uniforms
	glGenVertexArrays(1, &rect_program.VAO);
	glBindVertexArray(rect_program.VAO);
	glGenBuffers(3, (GLuint*)(&rect_program.buffer));

  const auto VAO = rect_program.VAO;
  const auto VBO = rect_program.buffer.vertex;
  const auto EBO = rect_program.buffer.elements;
  const auto IBO = rect_program.buffer.instance;

  constexpr auto vertex_position = rect_program.attrib.vertex_position;
  constexpr auto instance_rect = rect_program.attrib.instance_offset;

	// Setup element array buffer.
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(glm::uvec3) * corner_indices.size(), corner_indices.data(), GL_STATIC_DRAW);

  // Bind vertex attributes: first per-vertex, then per-instance.
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * corner_vertices.size(), corner_vertices.data(), GL_STATIC_DRAW);
    glEnableVertexAttribArray(vertex_position);
    glVertexAttribPointer(    vertex_position, 2, GL_FLOAT, GL_FALSE, 0, 0);

  glBindBuffer(GL_ARRAY_BUFFER, IBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Instance) * instances.size(), instances.data(), GL_STATIC_DRAW);
    glEnableVertexAttribArray(instance_rect);
    glVertexAttribPointer(    instance_rect, 4, GL_FLOAT, GL_FALSE, sizeof(Instance), (void*)(0));
    glVertexAttribDivisor(    instance_rect, 1);  // sets this attribute to be instanced

  // compile shader program
  GLuint rect_program_id = CreateProgram(rect_program.sources, {"vertex_position", "instance_rect"});
  glUseProgram(rect_program_id);

  struct uniform_ {
    // GLint view = 0;
    GLint projection = 0; // TODO @ref1
    // GLint wireframe = 0;
  } uniform;

  // uniform.view      = glGetUniformLocation(rect_program_id, "view");
  uniform.projection = glGetUniformLocation(rect_program_id, "projection"); // TODO @ref1
  // uniform.wireframe = glGetUniformLocation(rect_program_id, "wireframe");

  /// Render Loop ===------------------------------------------------------------------------===///

  double fps_counter_time = glfwGetTime();
  int framecounter = 0;
  double moving_avg_framerate = 60.f;
  double framerate = 60.f;
  double delta_time = 0.f;

  Profiler pr;

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

    /// Development Messages ===-------------------------------------------------------------===///

    std::vector<std::string> status_messages;
    auto status = [&status_messages](std::string m) {
      status_messages.push_back(m);
    };

    /// Handle Updates ===-------------------------------------------------------------------===///

    // handle updates that need delta_time, e.g. physics, movement

    if constexpr(PROFILING) { pr.event("handle updates"); }

    editor.tick(delta_time);

    /// PreRender Compution ===----------------------------------------------------------------===///

    float aspect = static_cast<float>(window.width()) / window.height();
    // glm::mat4 projection_matrix = glm::ortho(0.f, (float)(window.width()), (float)(window.height()), 0.f); // TODO @ref1
    glm::mat4 projection_matrix{1};
    glm::mat4 view_matrix(1);

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
    glDisable(GL_CULL_FACE);

    // Clear
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glViewport(0, 0, window.width(), window.height());
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Draw Rectangles
    glUseProgram(rect_program_id);

    // Pass in Uniform
    glUniformMatrix4fv(uniform.projection, 1, GL_FALSE, &projection_matrix[0][0]); // TODO @ref1
    // glUniformMatrix4fv(uniform.view,       1, GL_FALSE, &view[0][0]);
    // glUniform1i(       uniform.wireframe, wireframe_mode);

    glBindVertexArray(VAO);

    glDrawElementsInstanced(GL_TRIANGLES, corner_indices.size() * 3, GL_UNSIGNED_INT, NULL, instances.size());

    editor.render(window, tr);
    if (not editor._menus.empty())
      {
        status("menu selection: " + str(editor._menus.back().cursor));
      }

    if constexpr(PROFILING) { pr.event("render to screen"); }

    /// FPS Counter ===------------------------------------------------------===///

    auto tilde_width = tr.textWidth("~");
    tr.renderText("FPS: " + str(framerate), window.width() - 300 + tilde_width, 50, 1);
    tr.renderText("~FPS: " + str(moving_avg_framerate), window.width() - 300, 80, 1);

    /// Render Messages ===--------------------------------------------------===///

    auto list_text = [&tr](std::vector<std::string> lines, glm::ivec2 start_pos, std::string title = "") {
      int count = 0;

      if (title != "") {
        tr.renderText(title, start_pos.x, start_pos.y + count++ * 30, 1);
        std::string titlebar = "";
        for (uint i = 0; i < title.length(); ++i) {
          titlebar += "-";
        }
        tr.renderText(titlebar, start_pos.x, start_pos.y + count++ * 30, 1);
      }

      for (std::string l : lines) {
        tr.renderText(l, start_pos.x, start_pos.y + count++ * 30, 1);
      }
    };

    if (not editor._menus.empty()) {
      list_text(editor.command_history, {window.width() - 500, window.height() - 700}, "history");
    }

    list_text(status_messages, {window.width() - 500, window.height() - 500}, "status");

    if constexpr(PROFILING) {
      pr.event("render text");
      pr.endFrame();

      // 2 60th's of a second is a bad frame.  only keep bad frames
      if (pr._frames.back().elapsedTime() < 2/60.0) {
        pr.removeLastFrame();
      }
      std::vector<std::string> frame_messages;
      if (not pr._frames.empty()) {
        for (const Event& event : pr._frames.back()._events) {
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
