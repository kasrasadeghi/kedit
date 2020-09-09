#include "Editor.hpp"

// File: Editor.cpp
// Commentary:
//      Implementation of pointer-move garbage collection for managing
// filebuffers and menus along with the page referencer.


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

// Commentary:
//    Both allocFileBuffer and allocMenu require pointer moving when
// their respective backing store moves.  When moving _filebuffers,
// find which pages are FileBufferT's and fix them.
FileBuffer* Editor::allocFileBuffer(void)
  {
    // allocation routine
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

    // initialization
    FileBuffer& curr = _filebuffers.back();
    curr.page._type = Type::FileBufferT;
    curr._search.common = &search_common;

    _pages.push_back(&curr.page);
    return &curr;
  }

Menu* Editor::allocMenu(void)
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

    _pages.push_back(&curr.page);
    return &curr;
  }

// Commentary:
//      A menu exists in 2 different contexts:
//   1. _menus,   where the Menu itself and the Page lives as a component.
//                The Page points to the buffer.
//   2. _pages,   where a pointer to its Page lives
//      To free a menu, we must remove the pointer in _pages for the menu that's
// being freed. Because nothing aliases the contents of _pages, we can free the
// Page* in _pages first, as we don't need to fix the Page* for the Menu we are
// about to remove anyways.
// So:
//   1. free Page* in _pages.
//   2. free Menu in _menus
//      - decrement page* of all menus that refer to a menu after the one removed
//      - apply offset to pages if menu backing store moves
void Editor::freeMenu(Menu* menu)
  {
    // garbage collect from _pages
    _pages.erase(std::remove_if(_pages.begin(), _pages.end(),
                                [&](Page* curr_page) { return curr_page == (Page*)menu; }),
                 _pages.end());
    // NOTE: nobody refers to pages, so there's no pointer-moving to do

    // garbage collect from _menus
    // - pointer-move _pages if _menus moves
    std::vector<unsigned char> pages_filter;
    for (auto* page : _pages)
      {
        pages_filter.push_back(page->_type == Type::MenuT);
      }

    auto* menu_before = _menus.data();
    _menus.erase(std::remove_if(_menus.begin(), _menus.end(),
                                [&](const Menu& curr_menu) { return &curr_menu == menu; }),
                 _menus.end());
    auto* menu_after = _menus.data();

    if (menu_before != menu_after)
      {
        println("LOG: _menus shrink with move");
      }
    else
      {
        println("LOG: _menus shrink without move");
      }

    // zip(pages_filter, _pages)
    for (size_t i = 0; i < pages_filter.size(); ++ i)
      {
        if (pages_filter[i])
          {
            auto old_index = (((Menu*)_pages[i]) - menu_before);

            // the old_index is one less if we removed an element before it
            auto removed_index = menu - menu_before;
            if (old_index > removed_index)
              {
                -- old_index;
              }

            _pages[i] = (Page*)(menu_after + old_index);
          }
      }
  }

void Editor::freeFileBuffer(FileBuffer* filebuffer)
  {
    // garbage collect from _pages
    _pages.erase(std::remove_if(_pages.begin(), _pages.end(),
                                [&](Page* curr_page) { return curr_page == (Page*)filebuffer; }),
                 _pages.end());
    // NOTE: nobody refers to pages, so there's no pointer-moving to do

    // garbage collect from _filebuffers
    // - pointer-move _pages if _filebuffers moves
    std::vector<unsigned char> pages_filter;
    for (auto* page : _pages)
      {
        pages_filter.push_back(page->_type == Type::FileBufferT);
      }

    auto* filebuffer_before = _filebuffers.data();
    _filebuffers.erase(std::remove_if(_filebuffers.begin(), _filebuffers.end(),
                                      [&](const FileBuffer& curr_filebuffer) { return &curr_filebuffer == filebuffer; }),
                 _filebuffers.end());
    auto* filebuffer_after = _filebuffers.data();

    if (filebuffer_before != filebuffer_after)
      {
        println("LOG: _filebuffers shrink with move");
      }
    else
      {
        println("LOG: _filebuffers shrink without move");
      }

    // zip(pages_filter, _pages)
    for (size_t i = 0; i < pages_filter.size(); ++ i)
      {
        if (pages_filter[i])
          {
            auto old_index = (((FileBuffer*)_pages[i]) - filebuffer_before);

            // the old_index is one less if we removed an element before it
            auto removed_index = filebuffer - filebuffer_before;
            if (old_index > removed_index)
              {
                -- old_index;
              }

            _pages[i] = (Page*)(filebuffer_after + old_index);
          }
      }
  }

// TODO could have optimization for current menu, _pages.pop_back instead of erase-remove
void Editor::freeCurrentMenu(void)
  { freeMenu(currentMenu()); }

void Editor::freeCurrentFileBuffer(void)
  { freeFileBuffer(currentFileBuffer()); }

void Editor::freeCurrent(void)
  {
    if (Type::FileBufferT == currentPage()->_type)
      {
        freeCurrentFileBuffer();
      }
    else if (Type::MenuT == currentPage()->_type)
      {
        freeCurrentMenu();
      }
    else
      {
        printerrln("ERROR: freeCurrent() with current page type: ", currentPage()->_type);
      }
  }
