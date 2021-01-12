#pragma once

#include "FileBuffer.hpp"
#include "Menu.hpp"
#include "Page.hpp"
#include "GraphicsContext.hpp"
#include "Clipboard.hpp"
#include "Search.hpp"

#include <kgfx/TextRenderer.hpp>
#include <backbone-core-cpp/StrView.hpp>
#include <backbone-core-cpp/Filesystem.hpp>

#include <string>
#include <vector>

#include <cstdlib>
#include <unistd.h> // chdir

struct Editor {
  std::vector<FileBuffer> _filebuffers;
  std::vector<Menu>   _menus;

  std::vector<Page*> _pages;

  std::vector<std::string> command_history;

  Clipboard clipboard;
  SearchCommon search_common;

  bool _control_mode = true;
  bool _control_mode_release_exit = false;

  /// Initialization ===----------------------------------------------------------------------===///

  inline void init(void)
    {
      search_common.init();
    }

  /// Memory Management ===-------------------------------------------------------------------===///

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
      currentPage()->buffer.line_scroller.target += scroll_y;
    }

  inline void tick(double delta_time)
    {
      for (Page* page : _pages)
        {
          page->buffer.tick(delta_time);
        }
    }

  inline void swapToPage(size_t n)
    {
      // put the n'th page at the end
      Page* temp = _pages.at(n);
      _pages.erase(_pages.begin() + n);
      _pages.push_back(temp);
    }

  // check if we're opening a menu from another menu
  // - returns true if the current menu is the destination
  inline bool menuToMenuTransitionCheck(const std::string& destination)
    {
      // we're constructing the first page
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

  /// Menus ===-------------------------------------------------------------------------------===///

  void openBrowser(void);

  void makeBrowser(Menu&);

  void openSwap(void);

  void makeSwap(Menu&);

  /// Graphics ===----------------------------------------------------------------------------===///

  // TODO text renderer needs to have a Z level argument
  // TODO render background at different Z levels
  void render(GraphicsContext& gc);

  Cursor getCurrentCursor(void);

  void addRectangles(GraphicsContext& gc);

  void addBackground(GraphicsContext& gc);

  /// Interaction ===-------------------------------------------------------------------===///

  void handleKey(int key, int scancode, int action, int mods);
  [[nodiscard]] bool handleKeyControl(int key, int scancode, int action, int mods);
  void handleChar(unsigned char codepoint);

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
          print("  (addr, 0x", std::hex, (uintptr_t)page, std::dec, ")");
          println();
        }
      println("]");
    }
};
