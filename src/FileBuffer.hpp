#pragma once

#include "Buffer.hpp"
#include "PageT.hpp"
#include "Page.hpp"
#include "Cursor.hpp"
#include "History.hpp"
#include "CursorMove.hpp"
#include "Clipboard.hpp"
#include "Search.hpp"

#include <backbone-core-cpp/File.hpp>
#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Str.hpp>

#include <string>

/// NOTE: initialization routine
// _search.common = editor.search_common
// page._type = FileBufferT | MenuT
struct FileBuffer {
  Page page;

  File file;
  time_t last_modify_time = 0;

  Cursor cursor;
  Cursor shadow_cursor;
  Rope rope;
  History history;

  Search _search;

  // CONSIDER: implementing some kind of plugin system that adds stuff to FileBuffers and Editor
  // - probably use some kind of function hook system

  inline void destroy()
    {
      File::close(std::move(file));
    }

  inline void preparePageForRender(void)
    {
      // copy from backing store into rendering view to prepare to unmap file
      page.buffer.contents.lines.clear();
      for (std::string& line : rope.lines)
        {
          page.buffer.contents.lines.push_back(line);
        }
    }

  inline void loadFromPath(StringView file_path)
    {
      // TODO make sure buffer unreads and closes file
      file = File::openrw(file_path);
      last_modify_time = file.modify_time();

      if (0 == file.size())
        {
          println("LOG: handle empty file");
          rope.lines.push_back("");
          preparePageForRender();
          return;
        }

      StringView file_contents = file.read();
      // TODO is there a way to lazily parse into lines?

      // parse into lines and making backing store separate from mapped file
      page.buffer.contents.make(file_contents);
      for (StringView& line : page.buffer.contents.lines)
        {
          rope.lines.push_back(line.stringCopy());
        }

      // TODO probably be more efficient than this
      // - there is a parse, then a copy, then a reconstruction of the array that points to the about-to-be-closed file
      preparePageForRender();

      // unmap file and prepare for editting
      File::unread(std::move(file_contents));

      // TODO consider closing the file here?
      // - would have to change invariant to not use file size or to cache file size

      // TODO get system time when opening file, then before writing file make sure that the modified time is not after when you opened it
      // maybe store the original version of the file somewhere
    }

  inline bool invariant()
    {
      return page._type == Type::FileBufferT
        && file.size() > 0
        && (uint64_t)(file.size()) > page.buffer.contents.length();
    }

  /// Render ===------------------------------------------------------------------------===///

  void render(GraphicsContext& gc);
  void addCursors(GraphicsContext& gc, bool control_mode, bool active);
  void addSearchResults(GraphicsContext& gc);

  /// Interaction ===-------------------------------------------------------------------===///

  inline void _correctCursorPastEndOfLine()
    {
      // TODO: implement phantom cursor
      // correct cursor if off the end
      if (rope.lines.at(cursor.line).length() < cursor.column)
        {
          Move::endOfLine(cursor, rope);
        }
    }

  void handleKey(int key, int scancode, int action, int mods);
  void handleKeySearch(int key, int scancode, int action, int mods);
  void handleKeyEdit(int key, int scancode, int action, int mods);
  void handleChar(unsigned int codepoint);
  void handleKeyControl(int key, int scancode, int action, int mods);

  inline void undo(void)
    {
      if (history.commands.empty()) return;

      auto command = history.pop();

      auto cursor_before = [&](){
                             if (auto before = command.maybe_find("before-cursor"); before)
                               cursor = history.parseCursor(*before.value());
                           };

      if ("enter" == command.value)
        {
          cursor_before();
          rope.linemerge(cursor);
          preparePageForRender();
          return;
        }

      if ("char" == command.value)
        {
          cursor_before();
          rope.chardelete(cursor);
          preparePageForRender();
          return;
        }

      if ("tab" == command.value)
        {
          cursor_before();
          rope.chardelete(cursor);
          rope.chardelete(cursor);
          preparePageForRender();
          return;
        }

      // texp(shift-tab <before-cursor> [" ","  "]
      if ("shift-tab" == command.value)
        {
          cursor_before();
          rope.lines.at(cursor.line).insert(0, command[1].value);
          return;
        }

      auto undelete = [&](const std::string& c, Cursor loc) {
                        assert(c.length() == 1);
                        if (c == "\n")
                          { rope.linebreak(loc); }
                        else
                          { rope.insert(c, loc); }
                      };

      // texp([delete,backspace] <before-cursor> <char>)

      if ("delete" == command.value)
        {
          cursor_before();
          auto c = command[1].value;

          undelete(c, cursor);

          preparePageForRender();
          return;
        }

      if ("backspace" == command.value)
        {
          // TODO CURRENT: backspace's after is its before minus the vector of difference given by the dimensions of removed text

          cursor_before();

          auto c = command[1].value;

          Cursor insert_loc = cursor;
          if (c == "\n")
            { Move::up(insert_loc, rope); }
          else
            { Move::left(insert_loc, rope); }

          undelete(c, insert_loc);

          preparePageForRender();
          return;
        }

      // paste before-cursor@0 index@1 clipboard_addr@2
      if ("paste" == command.value)
        {
          cursor_before();

          constexpr auto int_parse = [](const std::string& s) -> size_t {
                                       return std::stoull(s);
                                     };
          auto index = int_parse(command[1].value);
          auto clipboard = (Clipboard*)(int_parse(command[2].value));
          const Rope& store = clipboard->kill_ring[index];

          Cursor end_of_block = cursor;
          Move::forwardBlock(end_of_block, rope, store);
          rope.erase(cursor, end_of_block);

          preparePageForRender();
          return;
        }

      println("UNHANDLED:\n  ", command.paren());
    }

  inline void search(bool shifted)
    {
      // CONSIDER removing offset

      // TODO when adding non-cursor search query, differentiate between cursor and non-cursor search
      // - cursor search just searches between the two cursors
      // - non-cursor makes you type in the query
      //
      // if selection search,
      //   index should be the lesser cursor
      //   search.offset should either be 0 or query.length()
      //
      // if non-selection search,
      //   if cursor is within a result,
      //     offset is based on that
      //     index is also zero
      //   otherwise
      //     offset is -1 i.e. maximal integer
      //     index is the first result that is after the cursor

      bool diffline = cursor.line != shadow_cursor.line;

      /// ==== Search without Valid Selection ====
      if (not shifted
          || diffline
          || cursor == shadow_cursor)
        {
          if (diffline && shifted && (cursor != shadow_cursor))
            {
              println("WARNING: cannot search multiple lines, using empty search query");
            }

          _search.common->active = true;

          if ("" != _search.common->_query)
            {
              println("LOG: scanning on previous query '" + _search.common->_query + "'");
              _search.common->scanAll(rope, _search);
            }
          return;
        }

      /// ==== Search on Selection ====
      // TODO rework on selection mode
      /// if shift is pressed and there is a valid selection
      /// - search using the selection

      auto begin_column = cursor.column;
      auto end_column = shadow_cursor.column;
      if (begin_column > end_column) std::swap(begin_column, end_column);

      // NOW SOON: consider how the query string is updated by the content
      _search.common->setQuery(rope.lines.at(cursor.line).substr(begin_column, end_column - begin_column));
      _search.common->scanAll(rope, _search);

      // TODO: search binding to cycle through history of searched items, like M-n M-p in emacs

      // CONSIDER: std::binary_search instead of std::find
      // assign cursor offsets because we're searching for the symbol under the cursor/ in the selection
      if (cursor < shadow_cursor)
        {
          _search.offset = 0;
          auto index_ptr = std::find(_search.results.begin(), _search.results.end(), cursor);
          assert(index_ptr != _search.results.end());
          _search.index = index_ptr - _search.results.begin();
        }
      else
        {
          _search.offset = _search.common->_query.length();
          _search.index = std::find(_search.results.begin(), _search.results.end(), shadow_cursor) - _search.results.begin();
        }
    }

  inline void save(void)
    {
      // TODO make sure the write is synchronized and completes before program termination

      if (last_modify_time != file.modify_time())
        { println("WARNING: file modified after opening"); }

      // TODO check for first dirty line to seek and not rewrite pre-dirty segment
      std::string acc;
      for (const auto& line : rope.lines) acc += line + "\n";
      file.overwrite(acc);

      last_modify_time = file.modify_time();
    }

  // copy selection between shadow cursor and main cursor
  //
  // NOTE: filebuffer takes care of selection,
  // rope takes care of copying text area,
  // and editor takes care of storing ropes in clipboard kill ring
  // - you can interchange selection strategies without changing filebuffer's interface
  inline void copy(Rope& store)
    {
      // TODO: should copy line
      if (shadow_cursor == cursor) return;

      store.make(rope, shadow_cursor, cursor);
    }

  inline void paste(const Rope& store, size_t clipboard_index, void* clipboard_addr)
    {
      history.push("paste");
      history.addCursor(cursor, "before-cursor");

      // TODO: fix this, maximal janky
      history.add(str(clipboard_index));
      history.add(str((size_t)(clipboard_addr)));

      rope.insert(store, cursor);
      Move::forwardBlock(cursor, rope, store);

      preparePageForRender();
    }
};
