#pragma once

#include "Buffer.hpp"
#include "PageT.hpp"
#include "Page.hpp"
#include "Cursor.hpp"
#include "History.hpp"
#include "CursorMove.hpp"
#include "Clipboard.hpp"

#include <backbone-core-cpp/File.hpp>
#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Str.hpp>

#include <string>

struct FileBuffer {
  Page page;

  File file;
  time_t last_modify_time = 0;

  Cursor cursor;
  Cursor shadow_cursor;
  Rope rope;
  History history;

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

  inline void render(GraphicsContext& gc)
    {
      uint64_t line_number = 0;

      double xpos = page.top_left_position.x + page.offset.x;
      double ypos = page.top_left_position.y + page.offset.y;

      for (size_t line_i = 0; line_i < page.buffer.contents.lines.size(); ++line_i)
        {
          StringView line = page.buffer.contents.lines[line_i];
          double current_offset = (gc.line_height * page.buffer.line_scroller.position);
          double curr_ypos = current_offset + (ypos + (gc.line_height * line_number));

          if (curr_ypos < (uint64_t)(gc.window->height() + gc.line_height) && curr_ypos > (uint64_t)(0))
            {
              if (cursor.line == line_i)
                gc.text(line, xpos, curr_ypos, glm::vec4{1});
              else
                gc.text(line, xpos, curr_ypos, glm::vec4{0.8, 0.8, 0.8, 1});
            }
          ++ line_number;
        }
    }

  inline void addCursors(GraphicsContext& gc, bool control_mode)
    {
      // TODO change for variable text width fonts
      float text_width = gc.tr.textWidth("a");

      gc.drawRectangle(page.textCoord(gc, cursor), {text_width, gc.line_height},
                       control_mode
                       ? glm::vec4{1, 0.7, 0.7, 0.5}
                       : glm::vec4{0.7, 1, 0.7, 0.5}, 0.4);

      gc.drawRectangle(page.textCoord(gc, shadow_cursor),
                       {text_width, gc.line_height},
                       {0.7, 0.7, 1.0, 0.5}, 0.4);

      // TODO investigate positive z layer being below text?
      // - maybe ortho proj doesn't flip?
    }


  /// Interaction ===-------------------------------------------------------------------===///

  inline void _cursorMoveToEndOfLine()
    {
      cursor.column = rope.lines.at(cursor.line).length();
    }

  inline void _correctCursorPastEndOfLine()
    {
      // TODO: implement phantom cursor
      // correct cursor if off the end
      if (rope.lines.at(cursor.line).length() < cursor.column)
        {
          _cursorMoveToEndOfLine();
        }
    }

  inline void handleKey(int key, int scancode, int action, int mods)
    {

      if (GLFW_PRESS == action || GLFW_REPEAT == action)
        {
          if (not cursor.invariant(rope.lines)) return;

          // DIRECTIONS

          if (GLFW_KEY_UP == key)
            {
              Move::up(cursor, rope);
              return;
            }

          if (GLFW_KEY_DOWN == key)
            {
              Move::down(cursor, rope);
              return;
            }

          if (GLFW_KEY_LEFT == key)
            {
              Move::left(cursor, rope);
              return;
            }

          if (GLFW_KEY_RIGHT == key)
            {
              Move::right(cursor, rope);
              return;
            }

          // SPECIAL MOVEMENT

          if (GLFW_KEY_HOME == key)
            {
              cursor.column = 0;
            }

          if (GLFW_KEY_END == key)
            {
              _cursorMoveToEndOfLine();
            }

          constexpr uint64_t PAGE_LINE_COUNT = 5;

          if (GLFW_KEY_PAGE_DOWN == key)
            {
              // TODO: replace with std::min?
              if (cursor.line < rope.lines.size() - 1 - PAGE_LINE_COUNT)
                {
                  cursor.line += PAGE_LINE_COUNT;
                }
              else
                {
                  cursor.line = rope.lines.size() - 1;
                }

              _correctCursorPastEndOfLine();
              return;
            }

          if (GLFW_KEY_PAGE_UP == key)
            {
              // TODO: replace with std::min?
              if (cursor.line > PAGE_LINE_COUNT)
                {
                  cursor.line -= PAGE_LINE_COUNT;
                }
              else
                {
                  cursor.line = 0;
                }

              _correctCursorPastEndOfLine();
              return;
            }
        }
    }

  inline void handleKeyEdit(int key, int scancode, int action, int mods)
    {
      // guards
      if (not cursor.invariant(rope.lines)) return;


      if (GLFW_PRESS != action and GLFW_REPEAT != action) return;

      if (GLFW_KEY_BACKSPACE == key)
        {
          history.push("backspace");
          history.addCursor(cursor, "before-cursor");

          if (Move::left(cursor, rope))
            { history.add(str(rope.chardelete(cursor))); }
          else
            { history.pop(); return; }

          preparePageForRender();
          return;
        }

      if (GLFW_KEY_DELETE == key)
        {
          history.push("delete");
          history.addCursor(cursor, "before-cursor");

          if (char c = rope.chardelete(cursor); c != '\0')
            { history.add(str(c)); }
          else
            { history.pop(); return; }

          preparePageForRender();
          return;
        }

      if (GLFW_KEY_ENTER == key)
        {
          history.push("enter");
          history.addCursor(cursor, "before-cursor");

          rope.linebreak(cursor);
          ++ cursor.line;
          cursor.column = 0;

          preparePageForRender();
          return;
        }

      if (GLFW_KEY_TAB == key)
        {
          if (GLFW_MOD_SHIFT & mods)
            {
              /// SHIFT TAB
              size_t whitespace_count = ([&]() -> size_t {

                  const auto& line = rope.lines.at(cursor.line);
                  for (size_t i = 0; i < line.length(); ++i)
                    {
                      if (line.at(i) != ' ') return i;
                    }
                  return line.length();
                })();

              if (0 == whitespace_count) { return; }

              history.push("shift-tab");
              history.addCursor(cursor, "before-cursor");

              if (1 == whitespace_count)
                {
                  history.add(" ");
                  rope.lines.at(cursor.line) == "";
                  cursor.column = 0;
                }
              else
                {
                  history.add("  ");
                  rope.lines.at(cursor.line).erase(0, 2);
                  cursor.column -= 2;
                }
            }
          else
            {
              /// TAB
              history.push("tab");
              history.addCursor(cursor, "before-cursor");

              rope.insert("  ", cursor);
              cursor.column += 2;
            }

          preparePageForRender();
          return;
        }
    }

  inline void handleChar(unsigned int codepoint)
    {
      // TODO check cursor in bounds/ check that lines is big enough to contain cursor
      if (not cursor.invariant(rope.lines)) return;

      history.push("char");
      history.addCursor(cursor, "before-cursor");
      history.add(str((char)codepoint));

      rope.insert((char)codepoint, cursor);

      ++ cursor.column;

      preparePageForRender();
    }

  inline void handleKeyControl(int key, int scancode, int action, int mods)
    {
      // guards
      if (not cursor.invariant(rope.lines)) return;

      // CONTROL

      if (GLFW_PRESS != action and GLFW_REPEAT != action) return;

      if (GLFW_KEY_Z == key)
        {
          undo();
        }

      if (GLFW_PRESS != action) return;

      if (GLFW_KEY_S == key)
        {
          save();
        }

      if (GLFW_KEY_SPACE == key)
        {
          // drop shadow cursor
          shadow_cursor = cursor;
          // CONSIDER: two shadow cursors for direct buffer to buffer yanks
          // TODO: move shadow cursor when region resizes to not allow for that shape
          // TODO: move shadow cursor when text is deleted before the shadow cursor
        }
    }

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

      print("UNHANDLED:\n  ");
      println(command.paren());
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
