#include "Editor.hpp"

// Note: only use this function to allocate buffers put in Pages accounted for
// in _pages.
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
Buffer* Editor::allocBuffer(void)
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
FileBuffer* Editor::allocFileBuffer(void)
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
    curr.page.buffer = allocBuffer();

    _pages.push_back(&curr.page);
    return &curr;
  }

// Commentary:
//      A menu exists in 3 different contexts:
//   1. _buffers, where its buffer lives
//   2. _menus,   where the Menu itself and the Page lives as a component.
//                The Page points to the buffer.
//   3. _pages,   where a pointer to its Page lives
//      To free a menu, we must free its buffer, which may move the buffers, which
// are refered to by the Pages in both _menus and _filebuffers.  We can use _pages
// to access all Pages, and thus fix all buffers pointers which are equally
// affected.  We can remove the pointer in _pages for the menu that's being freed.
// Because neither _menus nor _buffers refers to _pages, and we only use _pages
// to fix buffer pointers, we can free the Page* in _pages first, as we don't need
// to fix the Page* for the Menu we are about to remove anyways.
// So far:
//   1. free Page* in _pages.
//   2. free Buffer in _buffers.  <- Keep track of the buffers delta,
//                                   fix the pages that remain.
//   3. free Menu in _menus
void Editor::freeMenu(Menu* menu)
  {
    // garbage collect from _pages
    _pages.erase(std::remove_if(_pages.begin(), _pages.end(),
                                [&](Page* curr_page) { return curr_page == (Page*)menu; }),
                 _pages.end());
    // NOTE: nobody refers to pages, so there's no pointer-moving to do

    // buffer* is in page, in menu
    auto* buffptr = menu->page.buffer;
    auto* buffer_before = _buffers.data();
    // TODO optimize. can just memcpy instead of erase-remove idiom
    _buffers.erase(std::remove_if(_buffers.begin(), _buffers.end(),
                                  [&](const Buffer& buf) { return &buf == buffptr; }),
                   _buffers.end());
    auto* buffer_after = _buffers.data();

    // pointer-move _pages to handle _buffer move
    if (buffer_before != buffer_after)
      {
        println("LOG: _buffers shrink with move");
      }
    else
      {
        println("LOG: _buffers shrink without move");
      }

    for (auto* page : _pages)
      {
        auto old_index = (page->buffer - buffer_before);

        // the old_index is one less if we removed an element before it
        auto removed_index = buffptr - buffer_before;
        if (old_index > removed_index)
          {
            -- old_index;
          }

        page->buffer = buffer_after + old_index;
      }

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

    // buffer* is in page, in filebuffer
    auto* buffptr = filebuffer->page.buffer;
    auto* buffer_before = _buffers.data();
    // TODO optimize. can just memcpy instead of erase-remove idiom
    _buffers.erase(std::remove_if(_buffers.begin(), _buffers.end(),
                                  [&](const Buffer& buf) { return &buf == buffptr; }),
                   _buffers.end());
    auto* buffer_after = _buffers.data();

    // pointer-move _pages to handle _buffer move
    if (buffer_before != buffer_after)
      {
        println("LOG: _buffers shrink with move");
      }
    else
      {
        println("LOG: _buffers shrink without move");
      }

    for (auto* page : _pages)
      {
        auto old_index = (page->buffer - buffer_before);

        // the old_index is one less if we removed an element before it
        auto removed_index = buffptr - buffer_before;
        if (old_index > removed_index)
          {
            -- old_index;
          }

        page->buffer = buffer_after + old_index;
      }

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
