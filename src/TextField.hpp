#pragma once

#include "Rope.hpp"
#include "History.hpp"
#include "Clipboard.hpp"
#include "CursorMove.hpp"


// TODO gather common editor functionality between filebuffer and textfield in one common area
// - TODO extract clipboard user
// - TODO extract history user
// NOTE many things seem to have a "common" element (that lives in the Editor) and a "user" component (that lives in each page or somehow a child of the editor struct)

struct TextField {
  Rope rope;

  Cursor cursor;
  Cursor shadow_cursor;
  History history;

  inline void setContent(const std::string& s)
    {
      rope.lines.clear();
      rope.lines.push_back(s);
    }

  inline std::string string(void)
    { return (rope.lines.size() == 0) ? "" : rope.lines.at(0); }

  inline size_t length() const
    { return (rope.lines.size() == 0) ? 0 : rope.lines.at(0).length(); }

  // copy selection between shadow cursor and main cursor
  // - does not modify rope
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

  // return true if rope was modified
  inline bool paste(const Rope& store, size_t clipboard_index, void* clipboard_addr)
    {
      history.push("paste");
      history.addCursor(cursor, "before-cursor");

      // TODO: fix this, maximal janky
      history.add(str(clipboard_index));
      history.add(str((size_t)(clipboard_addr)));

      rope.insert(store, cursor);
      Move::forwardBlock(cursor, rope, store);

      return true;
    }

  // return true if rope was modified
  inline bool undo(void)
    {
      if (history.commands.empty()) return false;

      auto command = history.pop();

      auto cursor_before = [&](){
                             if (auto before = command.maybe_find("before-cursor"); before)
                               cursor = history.parseCursor(*before.value());
                           };

      if ("enter" == command.value)
        {
          cursor_before();
          rope.linemerge(cursor);
          return true;
        }

      if ("char" == command.value)
        {
          cursor_before();
          rope.chardelete(cursor);
          return true;
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

          return true;
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

          return true;
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

          return true;
        }

      print("UNHANDLED:\n  ");
      println(command.paren());
      return false;
    }

  /// Interaction ===-------------------------------------------------------------------===///

  void handleKey(int key, int scancode, int action, int mods);

  /// returns true if rope has been modified
  bool handleKeyEdit(int key, int scancode, int action, int mods);
  void handleKeyControl(int key, int scancode, int action, int mods);

  bool handleChar(unsigned int codepoint);
};
