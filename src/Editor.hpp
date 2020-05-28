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

    Texp cwd = pwd();

    // TODO only quote if whitespace appears in path names
    // TODO change the command for selecting a child path that is not a folder

    // browser menu layout
    // - working directory is the root, which is text
    // - children are buttons
    //   - folder children are "cd <folder name>"
    //   - file children can be opened with the editor

    curr._layout = Texp("text", {cwd.value});
    curr._layout.push(Texp("button", {Texp("\"..\""), Texp("\"cd ..\"")}));

    for (auto& child : cwd)
      {
        auto cmd = Texp("\"cd \'" + child.value.substr(1, child.value.length() - 2) + "\'\"");
        curr._layout.push(Texp("button", {child, cmd}));
      }

    curr.parseLayout(curr._layout);
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

inline void handleKey(int key, int scancode, int action, int mods)
  {
    // TODO check menu active
    Menu& curr = _menus.back();

    if (GLFW_PRESS == action)
      {
        if (GLFW_KEY_UP == key && curr.cursor != 0) {
          -- curr.cursor;
          return;
        }

        if (GLFW_KEY_DOWN == key && curr.cursor < curr.selectable_lines.size() - 1) {
          ++ curr.cursor;
          return;
        }
      }
  }

};
