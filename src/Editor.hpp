#pragma once

#include "FileBuffer.hpp"
#include "Menu.hpp"
#include "Page.hpp"
#include "GraphicsContext.hpp"

#include <kgfx/TextRenderer.hpp>
#include <backbone-core-cpp/StrView.hpp>
#include <backbone-core-cpp/Filesystem.hpp>

#include <string>
#include <vector>

#include <cstdlib>
#include <unistd.h>

struct Editor {
  std::vector<Buffer> _buffers;

  // TODO merge Buffer and Menu somehow
  std::vector<FileBuffer> _filebuffers;
  std::vector<Menu>   _menus;

  std::vector<Page*> _pages;

  std::vector<std::string> command_history;

  inline Buffer* allocBuffer(void)
    {
      _buffers.push_back(Buffer{});
      return &_buffers.back();
    }

  inline FileBuffer* allocFileBuffer(void)
    {
      _filebuffers.push_back(FileBuffer{});
      FileBuffer& curr = _filebuffers.back();
      curr.page._type = Type::FileBufferT;
      curr.page.buffer = allocBuffer();

      _pages.push_back(&curr.page);
      return &curr;
    }

  inline Menu* allocMenu(void)
    {
      _menus.push_back(Menu{});
      Menu& curr = _menus.back();
      curr.page._type = Type::MenuT;
      curr.page.buffer = allocBuffer();

      _pages.push_back(&curr.page);
      return &curr;
    }

  inline Page* currentPage(void)
    { return _pages.back(); }

  inline void loadFile(StringView file_path)
    {
      auto& curr = *allocFileBuffer();

      // TODO make sure buffer unreads and closes file
      curr.file = File::open(file_path);
      curr.file_contents = curr.file.read();
      curr.page.buffer->contents.make(curr.file_contents);
    }

  inline void verticalScroll(double scroll_y)
    {
      currentPage()->buffer->line_scroller.target += scroll_y;
    }

  inline void tick(double delta_time)
    {
      for (auto& buffer : _buffers)
        {
          buffer.tick(delta_time);
        }
    }

  inline void openBrowser(void)
    {
      allocMenu();
      makeBrowser();
    }

  inline void makeBrowser(void)
    {
      Menu& curr = _menus.back();

      Texp cwd = pwd();

      // TODO change the command for selecting a child path that is not a folder

      // browser menu layout
      // - working directory is the root, which is text
      // - children are buttons
      //   - folder children are "cd <folder name>"
      //   - file children can be opened with the editor

      // TODO "cd .."
      // - should select the child folder we just came from

      // TODO cd - to a folder we already have visited in this browser
      // - should select the child we had previously selected

      // TODO incremental/fuzzy search

      curr._layout = Texp("text", {cwd.value});
      curr._layout.push(Texp("button", {Texp("\"..\""), Texp("cd", {Texp("\"..\"")})}));

      for (auto& child : cwd)
        {
          if (child.value.ends_with("/\""))
            {
              auto cmd = Texp("cd", {child});
              curr._layout.push(Texp("button", {child, cmd}));
            }
          else
            {
              auto cmd = Texp("open", {child});
              curr._layout.push(Texp("button", {child, cmd}));
            }
        }

      auto unquote = [](std::string s) -> std::string { return s.substr(1, s.length() - 2); };

      Menu::FunctionTable function_table {
        {"cd",     [&](const Texp& cmd) -> void {
                     command_history.push_back("(cd " + cmd.paren() + ")");
                     std::string c = unquote(cmd.value);
                     int a = chdir(c.c_str());
                     println("'cd ", c.c_str(), "'  exit: ", a);
                     makeBrowser();
                   }},
        {"system", [&](const Texp& cmd) -> void {
                     std::string c = unquote(cmd.value);
                     system(c.c_str());
                     makeBrowser();
                   }},
        {"open",   [&](const Texp& cmd) -> void {
                     command_history.push_back("(open " + cmd.paren() + ")");
                     std::string c = unquote(cmd.value);
                     // deconstruct the last menu in _menus.
                     _menus.resize(_menus.size() - 1);
                     loadFile(c);
                   }}
      };

      curr.setHandlers(function_table);
      curr.parseLayout(curr._layout);
    }

  // TODO text renderer needs to have a Z level argument
  // TODO render background at different Z levels
  inline void render(GraphicsContext& gc)
    { currentPage()->render(gc); }

  inline void handleKey(int key, int scancode, int action, int mods)
    {
      // TODO closing buffer, switching active buffer
      if (action == GLFW_PRESS && key == GLFW_KEY_B)
        {
          if (_menus.empty())
            openBrowser();
        }

      currentPage()->handleKey(key, scancode, action, mods);
    }


  inline bool invariant(void)
    {
      bool acc = true;
      for (auto fb : _filebuffers)
        {
          acc &= fb.invariant();
        }
      return acc;
    }
};
