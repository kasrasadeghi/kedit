#pragma once

#include "Buffer.hpp"
#include "Menu.hpp"

#include <kgfx/TextRenderer.hpp>
#include <backbone-core-cpp/StrView.hpp>
#include <backbone-core-cpp/Filesystem.hpp>

#include <string>
#include <vector>

#include <cstdlib>
#include <unistd.h>

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
      makeBrowser();
    }

  inline void makeBrowser(void)
    {
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
      curr._layout.push(Texp("button", {Texp("\"..\""), Texp("cd", {Texp("\"..\"")})}));

      for (auto& child : cwd)
        {
          auto cmd = Texp("cd", {Texp("\"" + child.value.substr(1, child.value.length() - 2) + "\"")});
          curr._layout.push(Texp("button", {child, cmd}));
        }

      auto unquote = [](std::string s) -> std::string { return s.substr(1, s.length() - 2); };

      Menu::FunctionTable function_table {
        {"cd",     [&](const Texp& cmd) -> void {
                     std::string c = unquote(cmd.value);
                     int a = chdir(c.c_str());
                     println("'cd ", c.c_str(), "'  exit: ", a);
                     makeBrowser();
                   }},
        {"system", [&](const Texp& cmd) -> void { std::string c = unquote(cmd.value); system(c.c_str()); makeBrowser(); }}
      };

      // TODO should pass an vector of functions that take in Texps and do something

      curr.setHandlers(function_table);
      curr.parseLayout(curr._layout);
    }

  inline void render(RenderWindow& window, TextRenderer& tr)
    {
      for (Buffer& buffer : _buffers)
        {
          buffer.render(window, tr);
        }

      for (Menu& menu : _menus)
        {
          menu.render(window, tr);
        }
    }

  inline void handleKey(int key, int scancode, int action, int mods)
    {
      // TODO check menu active
      Menu& curr = _menus.back();
      curr.handleKey(key, scancode, action, mods);
    }

};
