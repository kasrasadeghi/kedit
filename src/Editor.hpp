#pragma once

#include "Buffer.hpp"
#include "Menu.hpp"

#include <kgfx/TextRenderer.hpp>
#include <backbone-core-cpp/StrView.hpp>
#include <backbone-core-cpp/Filesystem.hpp>

#include <string>
#include <vector>

struct Editor {
  std::vector<Buffer> _buffers;
  std::vector<Menu>   _menus;
  bool control_mode = false;

inline void loadFile(StringView file_path)
  {
    _buffers.push_back(Buffer{});
    Buffer& curr = _buffers.back();

    // TODO make sure buffer unreads and closes file
    curr.file = File::open(file_path);
    curr.file_contents = curr.file.read();
    curr.contents.make(curr.file_contents);
  }

inline void verticalScroll(double scroll_y)
  {
    Buffer& curr = _buffers.back();
    curr.line_scroller.target += scroll_y;
  }

inline void tick(double delta_time)
  {
    for (Buffer& buffer : _buffers)
      {
        buffer.tick(delta_time);
      }
  }

inline void openBrowser(void)
  {
    _menus.push_back(Menu{});
    Menu& curr = _menus.back();

    curr.layout = pwd();
    curr._layout_alloc = curr.layout.tabs();

    curr.rope.make(curr._layout_alloc);
  }

inline void render(RenderWindow& window, TextRenderer& tr)
  {
    for (Buffer& buffer : _buffers) {
      buffer.render(window, tr);
    }

    for (Menu& menu : _menus) {
      menu.render(window, tr);
    }
  }

inline void handleKeyPress(int key, int mods)
  {
    if (key == GLFW_KEY_LEFT_CONTROL)
      {
        control_mode = true;
      }

    if (key == GLFW_KEY_B)
      {
        openBrowser();
      }
  }
};
