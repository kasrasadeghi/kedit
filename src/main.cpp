#include <kgfx/RenderWindow.h>
#include <kgfx/TextRenderer.h>
#include <kgfx/Profiler.h>
#include <kgfx/Str.h>

constexpr bool PROFILING = true;

int main() {
  srand(time(NULL));

  // RenderWindow window {"Craftmine", 1920, 1080};
  RenderWindow window {"Craftmine"};
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

  TextRenderer tr {(float)window.width(), (float)window.height()};
  tr.renderText("generating terrain", window.width()/2 - 100, window.height()/2, 1, glm::vec4(1));
  window.swapBuffers();

  /// Pre-Render Instance Gen ===------------------------------------------------------------------------===///

  // std::vector<Instance> instances;
  // world.build(instances);

  // GLuint worldVAO;
  // struct VBO_ {
  //  GLuint vertex_buffer;
  //  GLuint instances_buffer;
  //  GLuint index_buffer;
  // } worldVBO;

	// glGenVertexArrays(1, &worldVAO);
	// glBindVertexArray(worldVAO);
	// glGenBuffers(3, (GLuint*)(&VBO));

	// Setup element array buffer.
	// glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, VBO.index_buffer);
  //   glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(glm::uvec3) * faces.size(), faces.data(), GL_STATIC_DRAW);

  // Bind vertex attributes: per-vertex, then per-instance
  // vertex attribute: vertex position
	// glBindBuffer(GL_ARRAY_BUFFER, VBO.vertex_buffer);
  //   glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec4) * vertices.size(), vertices.data(), GL_STATIC_DRAW);
  //   glEnableVertexAttribArray(0);
  //   glVertexAttribPointer(    0, 4, GL_FLOAT, GL_FALSE, 0, 0);

  // vertex attribute: instance offset
  // glBindBuffer(GL_ARRAY_BUFFER, VBO.instances_buffer);
  //   glBufferData(GL_ARRAY_BUFFER, sizeof(Instance) * instances.size(), instances.data(), GL_STATIC_DRAW);
  //   glEnableVertexAttribArray(1);
  //   glVertexAttribPointer(    1, 3, GL_FLOAT, GL_FALSE, sizeof(Instance), (void*)0);
  //   glVertexAttribDivisor(    1, 1);

    // vertex attribute: direction
  //   glEnableVertexAttribArray(2);
  //   glVertexAttribIPointer(   2, 1, GL_UNSIGNED_INT, sizeof(Instance), (void*)(sizeof(glm::vec3)));
  //   glVertexAttribDivisor(    2, 1);

    // vertex attribute: texture_index
  //   glEnableVertexAttribArray(3);
  //   glVertexAttribIPointer(   3, 1, GL_UNSIGNED_INT, sizeof(Instance), (void*)(sizeof(glm::vec3) + sizeof(GLuint)));
  //   glVertexAttribDivisor(    3, 1);

  // Gather shader program sources.
  // ShaderSource program_sources;
  // program_sources.vertex = world_vertex_shader;
  // program_sources.geometry = world_geometry_shader;
  // program_sources.fragment = world_fragment_shader;

  // Create shader program to bind
  // GLuint program_id = CreateProgram(program_sources, {"vertex_position", "instance_offset", "direction", "texture_index"});
  // glUseProgram(program_id);

  // Set up Uniforms
  // struct {
  //   GLint projection = 0;
  //   GLint view = 0;
	// } uniform, water_unifrom;

  // uniform.projection   = glGetUniformLocation(program_id, "projection");
  // uniform.view         = glGetUniformLocation(program_id, "view");

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

    /// Handle Updates ===-------------------------------------------------------------------===///

    // handle updates that need delta_time, e.g. physics, movement

    if constexpr(PROFILING) { pr.event("handle updates"); }

    /// Build Instances ===-------------------------------------------------------===///

    // glUseProgram(program_id);
    // glBindVertexArray(worldVAO);

    // world.build(instances);
    // glBindBuffer(GL_ARRAY_BUFFER, VBO.instances_buffer);
    // glBufferData(GL_ARRAY_BUFFER, sizeof(Instance) * instances.size(), instances.data(), GL_STATIC_DRAW);

    if constexpr(PROFILING) { pr.event("copy over instances"); }

    /// Render ===----------------------------------------------------------------===///
    float aspect = static_cast<float>(window.width()) / window.height();
    glm::mat4 projection_matrix(0);
    glm::mat4 view_matrix(0);
    glm::mat4 light_space_matrix(0);

    // glUseProgram(program_id);
    // glEnable(GL_CULL_FACE);
		// glCullFace(GL_BACK);
    glClearColor(0.5, 0.5, 0.5, 1); // Sky color
    // glEnable(GL_DEPTH_TEST);
		// glDepthFunc(GL_LESS);

    /// Render to Screen ===-----------------------------------------------------===///
    // Set rendering options
    // glViewport(0, 0, window.width(), window.height());
    // glBindFramebuffer(GL_FRAMEBUFFER, 0);
		// glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // glEnable(GL_BLEND);
    // glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    // Compute uniforms
    // light_space_matrix = projection_matrix * view_matrix;
		// projection_matrix = glm::perspective(glm::radians(45.0f), aspect, 0.5f, 1000.0f);
    // view_matrix = player.camera.get_view_matrix();

    // Pass uniforms in.
		// glUniformMatrix4fv(uniform.projection, 1, GL_FALSE, &projection_matrix[0][0]);
		// glUniformMatrix4fv(uniform.view,       1, GL_FALSE, &view_matrix[0][0]);
		// glUniformMatrix4fv(uniform.light_space,1, GL_FALSE, &light_space_matrix[0][0]);
		// glUniform4fv(      uniform.light_pos,  1, &light_position[0]);
    // glUniform1i(       uniform.wireframe,  wireframe_mode);

    // glDrawElementsInstanced(GL_TRIANGLES, faces.size() * 3, GL_UNSIGNED_INT, NULL, instances.size());

    if constexpr(PROFILING) { pr.event("render to screen"); }

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

      list_text(frame_messages, {400, 200});
    }

    /// Poll Events and Swap ===------------------------------------------------------===///

    window.swapBuffers();
    glfwPollEvents();
  }
}
