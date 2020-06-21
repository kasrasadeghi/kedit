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

  // Note: only use this function to allocate buffers put in Pages.
  //
  // Commentary:
  //      _filebuffers and _menus refer to _buffers, so when _buffers resizes,
  // they need to move pointers.  FileBuffers and Menus both refer to Buffers in
  // their Pages, which are kept track of in _pages, so we can refer to both
  // _filebuffers and _menus by using _pages.  Thus, when moving _buffers.data(),
  // for each page in _pages, fix page->buffer by apply the delta from the old
  // backing store to the new backing store.  delta = (new - old).
  //      _pages has a similar problem that is also solved by pointer moving.
  //
  // CONSIDER: alternatives to pointer moving
  // - Observable pointers
  // - indexes into each list
  // - use allocPage instead of allocBuffer
  // - don't have allocBuffer at all
  // - go completely SoA/data-oriented
  //
  // CONSIDER: strongly consider using vectors of pointers instead, as we don't
  //           really want to move around big objects.  Naively, this, along with
  //           removing _buffers and inlining the Buffer in Page (making it not a
  //           pointer), should make memory management much much easier than
  //           pointer-moving.
  inline Buffer* allocBuffer(void)
    {
      if (_buffers.size() == _buffers.capacity())
        {
          auto* before = _buffers.data();
          _buffers.push_back(Buffer{});
          auto* after = _buffers.data();
          if (before != after)
            {
              println("LOG: _buffers grow with move");
              for (auto* page : _pages)
                {
                  auto old_index = (page->buffer - before);
                  page->buffer = after + old_index;
                }
            }
          else
            {
              println("LOG: _buffers grow without move");
            }
        }
      else
        {
          auto* before = _buffers.data();
          _buffers.push_back(Buffer{});
          auto* after = _buffers.data();
          if (before != after)
            {
              println("SUSPICIOUS: _buffers move when not at capacity");
            }
        }
      return &_buffers.back();
    }

  // Commentary:
  //    Both allocFileBuffer and allocMenu require pointer moving when
  // their respective backing buffer moves.  When moving _filebuffers,
  // find which pages are FileBufferT's and fix them.
  inline FileBuffer* allocFileBuffer(void)
    {
      if (_filebuffers.size() == _filebuffers.capacity())
        {
          std::vector<unsigned char> pages_filter;
          for (auto* page : _pages)
            {
              pages_filter.push_back(page->_type == Type::FileBufferT);
            }

          auto* before = _filebuffers.data();
          _filebuffers.push_back(FileBuffer{});
          auto* after = _filebuffers.data();
          if (before != after)
            {
              println("LOG: _filebuffers grow with move");

              // zip(pages_filter, _pages)
              for (size_t i = 0; i < pages_filter.size(); ++ i)
                {
                  if (pages_filter[i])
                    {
                      auto old_index = (((FileBuffer*)_pages[i]) - before);
                      _pages[i] = (Page*)(after + old_index);
                    }
                }
            }
          else
            {
              println("LOG: _filebuffers grow without move");
            }
        }
      else
        {
          // TODO remove SUSPICIOUS warning
          auto* before = _filebuffers.data();
          _filebuffers.push_back(FileBuffer{});
          auto* after = _filebuffers.data();
          if (before != after)
            {
              println("SUSPICIOUS: _filebuffers move when not at capacity");
            }
        }

      FileBuffer& curr = _filebuffers.back();
      curr.page._type = Type::FileBufferT;
      curr.page.buffer = allocBuffer();

      _pages.push_back(&curr.page);
      return &curr;
    }

  inline Menu* allocMenu(void)
    {
      if (_menus.size() == _menus.capacity())
        {
          std::vector<unsigned char> pages_filter;
          for (auto* page : _pages)
            {
              pages_filter.push_back(page->_type == Type::MenuT);
            }

          auto* before = _menus.data();
          _menus.push_back(Menu{});
          auto* after = _menus.data();
          if (before != after)
            {
              println("LOG: _menus grow with move");

              // zip(pages_filter, _pages)
              for (size_t i = 0; i < pages_filter.size(); ++ i)
                {
                  if (pages_filter[i])
                    {
                      auto old_index = (((Menu*)_pages[i]) - before);
                      _pages[i] = (Page*)(after + old_index);
                    }
                }
            }
          else
            {
              println("LOG: _menus grow without move");
            }
        }
      else
        {
          // TODO remove SUSPICIOUS warning
          auto* before = _menus.data();
          _menus.push_back(Menu{});
          auto* after = _menus.data();
          if (before != after)
            {
              println("SUSPICIOUS: _menus move when not at capacity");
            }
        }

      Menu& curr = _menus.back();
      curr.page._type = Type::MenuT;
      curr.page.buffer = allocBuffer();

      _pages.push_back(&curr.page);
      return &curr;
    }

  inline void freeMenu(Menu* menu)
    {
      // TODO need to fix pointers in here too
      return;

      // buffer* is in page, in menu
      auto* buffptr = menu->page.buffer;
      // TODO optimize. can just memcpy instead of erase-remove idiom
      _buffers.erase(std::remove_if(_buffers.begin(), _buffers.end(), [&](const Buffer& buf) { return buffptr == &buf; }), _buffers.end());

      // garbage collect from _pages
      if (_pages.back() != (Page*)menu)
        {
          printerrln("LEAK: cannot garbage collect current menu from _pages");
          return;
        }
      _pages.pop_back();

      // garbage collect from _menus
      size_t menu_index = menu - _menus.data();
      if (menu_index != _menus.size() - 1)
        {
          printerrln("LEAK: cannot garbage collect current menu from _menus");
          return;
        }
      _menus.pop_back();
    }

  inline void freeCurrentMenu(void)
    { freeMenu(currentMenu()); }

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

  // TODO text renderer needs to have a Z level argument
  // TODO render background at different Z levels
  inline void render(GraphicsContext& gc)
    { currentPage()->render(gc); }

  inline void handleKey(int key, int scancode, int action, int mods)
    {
      if (GLFW_PRESS == action)
        {
          if (GLFW_KEY_B == key)
            openBrowser();
        }

      // TODO closing buffer, switching active buffer

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
