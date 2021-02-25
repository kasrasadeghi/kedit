#include "Editor.hpp"
#include "RectangleProgramContext.hpp"
#include "GraphicsContext.hpp"

#include <backbone-core-cpp/Path.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Profiler.hpp>
#include <kgfx/Str.hpp>

#include <glm/gtc/matrix_transform.hpp>

constexpr bool PROFILING = false;

int main(int argc, char* argv[]) {
  std::cout << std::boolalpha;

  // TODO support for windowed mode and resizing
  RenderWindow window {"Kedit", 2360, 1400};
  // RenderWindow window {"kedit"};
  window.setMousePos(window.width()/2.f, window.height()/2.f);

  glfwSwapInterval(1); // framerate set: 0 for uncapped, 1 for monitor refresh rate

  Editor editor;
  editor.init();

  // TODO handle more than one argument?
  if (argc > 1) {
    std::string filepath = argv[1];

    if (is_file(filepath)) {
      std::string parent = parent_dir(filepath);
      if (0 != chdir(parent.c_str())) {
        perror(str("kedit (cd '" + parent + "'):").c_str());
        exit(1);
      }

      editor.loadFile(filepath);
    } else if (is_directory(filepath)) {
      if (0 != chdir(filepath.c_str())) {
        perror("kedit");
        exit(1);
      }
      editor.openBrowser();
    } else {
      print("WARNING: unhandled argument '",
            filepath, "' is neither file nor directory");
      editor.openBrowser();
    }
  } else {
    editor.openBrowser();
  }

  editor.setWindowClose([&]() { window.close(); });

  bool wireframe_mode = false;

  // TODO consider making viewable menu of callback history
  window.setKeyCallback([&](int key, int scancode, int action, int mods) {
    // TODO add to debug mode or something
    if (editor._control_mode && key == GLFW_KEY_G && action == GLFW_PRESS) {
      wireframe_mode = !wireframe_mode;
      if (wireframe_mode) glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      else                glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }

    editor.handleKey(key, scancode, action, mods);
  });

  window.setCharCallback([&](unsigned int codepoint) {
    editor.handleChar(codepoint);
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

  GraphicsContext gc { &window, parent_dir(argv[0]) };
  gc.initOptions();

  // handle graphics configuration at this point
  editor.initGraphics(gc);

  /// Load Screen ===-------------------------------------------------------------------------===///
  gc.clear(0, 0, 0, 1);
  gc.scissorFull();
  gc.text("loading", window.width()/2 - 100, window.height()/2, glm::vec4(1));
  window.swapBuffers();

  gc.rectprog.init();

  /// Render Loop ===-------------------------------------------------------------------------===///

  Profiler pr { 60.0 };

  while (window.isOpen()) {

    /// Update Frame Data ===-----------------------------------------------------------------===///

    pr.startFrame();

    /// Development Messages ===--------------------------------------------------------------===///

    std::vector<std::string> status_messages;
    auto status = [&status_messages](std::string m) {
      status_messages.push_back(m);
    };

    auto list_text = [&](std::vector<std::string> lines, glm::ivec2 start_pos, std::string title = "") {
      int count = 0;

      if (title != "") {
        gc.text(title, start_pos.x, start_pos.y + count++ * gc.line_height, glm::vec4(1));
        std::string titlebar = "";
        for (uint i = 0; i < title.length(); ++i) {
          titlebar += "-";
        }
        gc.text(titlebar, start_pos.x, start_pos.y + count++ * gc.line_height, glm::vec4(1));
      }

      for (std::string l : lines) {
        gc.text(l, start_pos.x, start_pos.y + count++ * gc.line_height, glm::vec4(1));
      }
    };

    /// Handle Updates ===--------------------------------------------------------------------===///
    // handle updates that need delta_time, e.g. physics, movement

    if constexpr(PROFILING) { pr.event("handle updates"); }

    editor.tick(pr.delta_time);

    /// Editor Info Status ===----------------------------------------------------------------===///

    status(str(editor.currentPage()->_type) + " :current page type ");
    status(str(editor._pages.size())        + " :page count "       );
    status(str(editor._menus.size())        + " :menu count "       );
    status(str(editor._filebuffers.size())  + " :filebuffer count " );
    status(str(editor._control_mode)        + " :control mode "     );

    /// Render to Screen ===------------------------------------------------------------------===///
    gc.renderOptions();

    editor.render(gc);

    // TODO translucency on top of text goes after editor render

    gc.scissorFull();

    status("scroll position: " + str(editor.currentPage()->buffer.line_scroller.position));
    status("scroll target:   " + str(editor.currentPage()->buffer.line_scroller.target));
    status("scroll delta:    " + str(pr.delta_time));
    status("scroll step:     " + str(editor.currentPage()->buffer.line_scroller.velocity * pr.delta_time));

    status("page list:");
    int i = 0;
    for (Page* page : editor._pages)
      {
        switch(page->_type) {
        case Type::FileBufferT:
          status(str(i) + ": file '" + ((FileBuffer*)(page))->file._name + "'");
          break;
        case Type::MenuT:
          status(str(i) + ": menu selection '" + str(((Menu*)(page))->cursor) + "'");
          break;
        case Type::NoneT:
          printerrln("ERROR: page of type none");
        }
        ++ i;
      }

    // render clipboard
    auto clipboard_count_position =
      editor.currentPage()->top_left_position
      + glm::vec2{editor.currentPage()->size.x + 10, gc.line_height};
    gc.text("clipboard count: " + str(editor.clipboard.kill_ring.size()),
            clipboard_count_position.x, clipboard_count_position.y,
            {1, 1, 1, 1});

    size_t line_offset = 1;
    for (size_t i = 1; i < 4 && i < editor.clipboard.kill_ring.size() + 1; ++i)
      {
        auto curr = (editor.clipboard.kill_ring.end() - i)->lines;
        list_text(curr,
                  clipboard_count_position + glm::vec2{0, gc.line_height * line_offset},
                  "clipboard" + str(i));
        line_offset += (2 + curr.size());
      }

    if constexpr(PROFILING) { pr.event("render to screen"); }

    /// FPS Counter ===-----------------------------------------------------------------------===///

    auto tilde_width = gc.tr.textWidth("~");
    gc.text("FPS: " + str(pr.framerate), window.width() - 300 + tilde_width, 50, glm::vec4(1));
    gc.text("~FPS: " + str(pr.moving_avg_framerate), window.width() - 300, 80, glm::vec4(1));

    /// Render Messages ===-------------------------------------------------------------------===///

    gc.text(editor.search_common._query, editor.currentPage()->size.x + 100, 100, glm::vec4(1));
    gc.text(str(editor._debug_counter), editor.currentPage()->size.x + 110, 170, glm::vec4(1));

    // if (not editor._menus.empty()) {
    //  list_text(editor.command_history, {window.width() - 500, window.height() - 700}, "history");
    // }

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

    /// Poll Events and Swap ===--------------------------------------------------------------===///

    window.swapBuffers();
    glfwPollEvents();
  }
}
