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

  std::vector<FileBuffer> _filebuffers;
  std::vector<Menu>   _menus;

  std::vector<Page*> _pages;

  std::vector<std::string> command_history;

  /// Memory Management ===-------------------------------------------------------------------===///

  Buffer* allocBuffer(void);
  FileBuffer* allocFileBuffer(void);
  Menu* allocMenu(void);

  void freeMenu(Menu* menu);
  void freeFileBuffer(FileBuffer* filebuffer);

  void freeCurrentMenu(void);
  void freeCurrentFileBuffer(void);
  void freeCurrent(void);

  /// Memory Management ===-------------------------------------------------------------------===///

  inline Page* currentPage(void)
    { return _pages.back(); }

  inline Menu* currentMenu(void)
    {
      if (currentPage()->_type != Type::MenuT) printerrln("ERROR: accessing current menu while current page is not menu");
      return (Menu*)currentPage();
    }

  inline FileBuffer* currentFileBuffer(void)
    {
      if (currentPage()->_type != Type::FileBufferT) printerrln("ERROR: accessing current filebuffer while current page is not filebuffer");
      return (FileBuffer*)currentPage();
    }

  inline void loadFile(StringView file_path)
    {
      auto& curr = *allocFileBuffer();
      curr.loadFromPath(file_path);
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

  // check if we're opening a menu from another menu
  // - returns true if the current menu is the destination
  inline bool menuToMenuTransitionCheck(const std::string& destination)
    {
      if (_pages.empty()) return false;

      if (Type::MenuT == currentPage()->_type)
        {
          auto* menu = currentMenu();
          if (menu->name == destination)
            {
              return true;
            }
          else
            {
              // we're on some other menu,
              // dispose of it and continue making the menu
              freeMenu(menu);
            }
        }
      return false;
    }

  inline void openBrowser(void)
    {
      if (menuToMenuTransitionCheck("File Browser")) return;
      allocMenu();
      makeBrowser();
    }

  inline void makeBrowser(void)
    {
      Menu& curr = _menus.back();

      curr.name = "File Browser";
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
                     freeCurrentMenu();
                     loadFile(c);
                   }}
      };

      curr.setHandlers(function_table);
      curr.parseLayout(curr._layout);
    }

  inline void openSwap(void)
    {
      if (menuToMenuTransitionCheck("Swap")) return;
      allocMenu();
      makeSwap();
    }

  inline void makeSwap(void)
    {
      Menu& curr = _menus.back();

      curr.name = "Swap";
      auto unquote = [](const std::string& s) -> std::string { return s.substr(1, s.length() - 2); };
      auto quote = [](const std::string& s) -> std::string {
                     std::string quoted = "\"" + s + "\"";
                     return quoted;
                   };

      curr._layout = Texp("text", {Texp(quote("Buffers"))});

      for (ssize_t page_i = _pages.size() - 1; page_i >= 0; -- page_i)
        {
          auto* page = _pages[page_i];
          if (page->_type == Type::MenuT)
            {
              // TODO don't swap to self
              // TODO swap to menu?
              // auto* menu = (Menu*)page;
              // auto menu_index_str = str(menu - _menus.data());
              // auto cmd = Texp("swap", {Texp("menu"), menu_index_str});
              // curr._layout.push(Texp("button", {"Menu " + menu_index_str, cmd}));

              // printerrln("UNSUPPORTED: switching to menu");
            }
          else if (page->_type == Type::FileBufferT)
            {
              // TODO file name might need to change if current directory is changed
              auto* filebuffer = (FileBuffer*)page;
              auto cmd = Texp("swap", {str(page_i)});

              std::string file_name = quote(filebuffer->file._name);
              curr._layout.push(Texp("button", {file_name, cmd}));
            }
          else
            {
              // printerrln("ERROR: Page type '", page->_type, "' found in page list.");
              // auto cmd = Texp("swap", {Texp("\"UNSUPPORTED\"")});
              // curr._layout.push(Texp("button", {cmd}));
            }
        }

      Menu::FunctionTable function_table {
        {"swap",   [&](const Texp& cmd) -> void {
                     command_history.push_back("(swap " + cmd.paren() + ")");

                     constexpr auto int_parse = [](const std::string& s) -> size_t {
                                                  return std::stoull(s);
                                                };
                     auto* curr = currentMenu();
                     swapToPage(int_parse(cmd.value));
                     freeMenu(curr);
                   }}
      };

      curr.setHandlers(function_table);
      curr.parseLayout(curr._layout);
    }

  inline void swapToPage(size_t n)
    {
      // put the n'th page at the end
      Page* temp = _pages.at(n);
      _pages.erase(_pages.begin() + n);
      _pages.push_back(temp);
    }

  // TODO text renderer needs to have a Z level argument
  // TODO render background at different Z levels
  inline void render(GraphicsContext& gc)
    { currentPage()->render(gc); }

  inline void handleKey(int key, int scancode, int action, int mods)
    {
      // TODO create new file
      // TODO create new buffer without file ?

      if (GLFW_PRESS == action)
        {
          if (GLFW_KEY_B == key)
            openBrowser();

          if (GLFW_KEY_S == key)
            openSwap();

          // CONSIDER: opening swap menu after closing current file
          if (GLFW_KEY_W == key)
            if (_pages.size() > 1)
              freeCurrent();
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

  inline void pageDump(void)
    {
      println("[");
      for (size_t i = 0; i < _pages.size(); ++ i)
        {
          print("  ", i, " ");
          auto* page = _pages[i];
          print("  (type, ", page->_type, ")");
          print("  (addr, 0x", std::hex, (uintptr_t)page, std::oct, ")");
          println();
        }
      println("]");
    }
};
