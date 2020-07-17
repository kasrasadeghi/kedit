#pragma once

#include "Buffer.hpp"
#include "PageT.hpp"
#include "Page.hpp"

#include "Cursor.hpp"

#include <backbone-core-cpp/File.hpp>
#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>
#include <kgfx/Str.hpp>

#include <string>

struct History {
  std::vector<Texp> commands;

  inline void push(std::string S)
    { commands.push_back(Texp(S)); }

  inline Texp pop(void)
    {
      auto copy = commands.back();
      commands.pop_back();
      return copy;
    }

  inline void addCursor(const Cursor& cursor)
    {
      if (commands.empty())
        {
          printerrln("ERROR: no command to add cursor to");
          return;
        }

      Texp cursor_texp {"cursor"};
      cursor_texp.push(str(cursor.line));
      cursor_texp.push(str(cursor.column));

      commands.back().push(cursor_texp);
    }

  inline void setFromCursorChild(Cursor& cursor, const Texp& texp)
    {
      constexpr auto int_parse = [](const std::string& s) -> size_t {
                                   return std::stoull(s);
                                 };

      for (auto& child : texp)
        {
          if (child.value == "cursor")
            {
              cursor = Cursor{int_parse(child[0].value), int_parse(child[1].value)};
              return;
            }
        }
      println("ERROR: could not find cursor in '" + texp.paren() + "'");
    }

  inline void setFromCursor(Cursor& cursor, const Texp& texp)
    {
      constexpr auto int_parse = [](const std::string& s) -> size_t {
                                   return std::stoull(s);
                                 };

      if (texp.value != "cursor")
        {
          println("ERROR: '" + texp.paren() + "' is not a cursor");
          return;
        }

      cursor = Cursor{int_parse(texp[0].value), int_parse(texp[1].value)};
    }

  inline void add(std::string S)
    {
      if (commands.empty())
        {
          printerrln("ERROR: no command to add '" + S + "' to");
          return;
        }

      commands.back().push(Texp(S));
    }
};


struct FileBuffer {
  Page page;

  File file;
  time_t last_modify_time = 0;

  Cursor cursor;
  std::vector<std::string> lines;
  struct History history;

  inline void destroy()
    {
      File::close(std::move(file));
    }

  inline void preparePageForRender(void)
    {
      // copy from backing store into rendering view to prepare to unmap file
      page.buffer->contents.lines.clear();
      for (std::string& line : lines)
        {
          page.buffer->contents.lines.push_back(line);
        }
    }

  inline void loadFromPath(StringView file_path)
    {
      // TODO make sure buffer unreads and closes file
      file = File::openrw(file_path);
      last_modify_time = file.modify_time();
      StringView file_contents = file.read();

      // TODO is there a way to lazily parse into lines?

      // parse into lines and making backing store separate from mapped file
      page.buffer->contents.make(file_contents);
      for (StringView& line : page.buffer->contents.lines)
        {
          lines.push_back(line.stringCopy());
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
        && (uint64_t)(file.size()) > page.buffer->contents.length();
    }

  inline void render(GraphicsContext& gc)
    {
      uint64_t line_number = 0;

      // TODO have constexpr PAGE_OFFSET
      double xpos = page.position.x + 50;
      double ypos = page.position.y + 50;

      for (size_t line_i = 0; line_i < page.buffer->contents.lines.size(); ++line_i)
        {
          StringView line = page.buffer->contents.lines[line_i];
          double current_offset = (30 * page.buffer->line_scroller.position);
          double curr_ypos = current_offset + (ypos + (30 * line_number));

          // TODO "+ 30" should be "+ text_height"
          if (curr_ypos < (uint64_t)(gc.window->height() + 30) && curr_ypos > (uint64_t)(0))
            {
              if (cursor.line == line_i)
                gc.text(line, xpos, curr_ypos, 1, glm::vec4{1});
              else
                gc.text(line, xpos, curr_ypos, 1, glm::vec4{0.8, 0.8, 0.8, 1});
            }
          ++ line_number;
        }
    }

  /// Interaction ===-------------------------------------------------------------------===///

  inline void handleKey(int key, int scancode, int action, int mods)
    {

      if (GLFW_PRESS == action || GLFW_REPEAT == action)
        {
          if (not cursor.invariant(lines)) return;

          // DIRECTIONS

          if (GLFW_KEY_UP == key && cursor.line != 0)
            {
              -- cursor.line;

              // correct cursor if off the end
              if (lines.at(cursor.line).length() < cursor.column)
                {
                  cursor.column = lines.at(cursor.line).length();
                }
              return;
            }

          if (GLFW_KEY_DOWN == key && cursor.line < lines.size() - 1)
            {
              ++ cursor.line;

              // TODO implement phantom cursor
              // correct cursor if off the end
              if (lines.at(cursor.line).length() < cursor.column)
                {
                  cursor.column = lines.at(cursor.line).length();
                }
              return;
            }

          if (GLFW_KEY_LEFT == key)
            {
              if (cursor.column != 0)
                {
                  -- cursor.column;
                  return;
                }

              // zero column, roll to previous line
              if (cursor.column == 0)
                {
                  if (cursor.line != 0)
                    {
                      -- cursor.line;
                      cursor.column = lines.at(cursor.line).length();
                    }
                  return;
                }
            }

          if (GLFW_KEY_RIGHT == key)
            {
              if (cursor.column < lines.at(cursor.line).size())
                {
                  ++ cursor.column;
                  return;
                }

              // roll over to next line
              if (cursor.column == lines.at(cursor.line).size()
                  && cursor.line < lines.size() - 1)
                {
                  cursor.column = 0;
                  ++ cursor.line;
                }
              return;
            }

          // SPECIAL MOVEMENT

          if (GLFW_KEY_HOME == key)
            {
              cursor.column = 0;
            }

          if (GLFW_KEY_END == key)
            {
              cursor.column = lines.at(cursor.line).length();
            }
        }
    }

  inline void _mergeLineWithNext(void)
    {
      lines.at(cursor.line) += lines.at(cursor.line + 1);
      lines.erase(lines.begin() + cursor.line + 1);
    }

  inline void _splitLineAtCursor(void)
    {
      std::string& line = lines.at(cursor.line);
      std::string head = line.substr(0, cursor.column);
      std::string tail = line.substr(cursor.column);

      line = head;
      lines.insert(lines.begin() + cursor.line + 1, tail);
    }

  inline char _deleteAtCursor(void)
    {
      auto& line = lines.at(cursor.line);
      char to_remove = line.at(cursor.column);
      line.erase(line.begin() + cursor.column);
      return to_remove;
    }

  inline void _insertAtCursor(char c)
    {
      auto& line = lines.at(cursor.line);
      line.insert(line.begin() + cursor.column, c);
    }

  inline void handleKeyEdit(int key, int scancode, int action, int mods)
    {
      // guards
      if (not cursor.invariant(lines)) return;


      if (GLFW_PRESS != action and GLFW_REPEAT != action) return;

      if (GLFW_KEY_BACKSPACE == key)
        {
          history.push("backspace");


          if (0 == cursor.column)
            {
              history.addCursor(cursor);

              if (0 == cursor.line) return;
              -- cursor.line;
              cursor.column = lines.at(cursor.line).length();
              history.add("\n");
              history.addCursor(cursor);
              _mergeLineWithNext();
            }

          else
            {
              history.addCursor(cursor);
              -- cursor.column;
              char removed = _deleteAtCursor();
              history.add(str(removed));
              history.addCursor(cursor);
            }

          preparePageForRender();
          return;
        }

      if (GLFW_KEY_DELETE == key)
        {
          history.push("delete");
          history.addCursor(cursor);

          if (lines.at(cursor.line).length() == cursor.column)
            {
              // cannot delete anything at the end of the last line,
              //   line_index = size - 1
              if (lines.size() - 1 == cursor.line) return;
              history.add("\n");
              _mergeLineWithNext();
            }

          else
            {
              char removed = _deleteAtCursor();
              history.add(str(removed));
            }

          preparePageForRender();
          return;
        }

      if (GLFW_KEY_ENTER == key)
        {
          history.push("enter");
          history.addCursor(cursor);

          if (0 == cursor.column)
            {
              lines.insert(lines.begin() + cursor.line, "");
              ++ cursor.line;
            }

          else if (lines.at(cursor.line).length() == cursor.column)
            {
              lines.insert(lines.begin() + cursor.line + 1, "");
              ++ cursor.line;
              cursor.column = 0;
            }

          else
            {
              _splitLineAtCursor();

              ++ cursor.line;
              cursor.column = 0;
            }

          preparePageForRender();
          return;
        }
    }

  inline void handleChar(unsigned int codepoint)
    {
      // TODO check cursor in bounds/ check that lines is big enough to contain cursor
      if (not cursor.invariant(lines)) return;

      history.push("char");
      history.addCursor(cursor);

      _insertAtCursor(codepoint);

      ++ cursor.column;

      preparePageForRender();
    }

  inline void handleKeyControl(int key, int scancode, int action, int mods)
    {
      // guards
      if (not cursor.invariant(lines)) return;

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
    }

  inline void undo(void)
    {
      if (history.commands.empty()) return;

      auto command = history.pop();

      if ("enter" == command.value)
        {
          history.setFromCursorChild(cursor, command);
          _mergeLineWithNext();
          preparePageForRender();
          return;
        }

      if ("char" == command.value)
        {
          history.setFromCursorChild(cursor, command);
          _deleteAtCursor();
          preparePageForRender();
          return;
        }

      if ("delete" == command.value)
        {
          auto c = command.back().value;
          history.setFromCursorChild(cursor, command);
          if (c != "\n")
            {
              _insertAtCursor(command.back().value[0]);
            }
          else
            {
              _splitLineAtCursor();
            }

          preparePageForRender();
          return;
        }

      // backspace after-cursor char before-cursor
      if ("backspace" == command.value)
        {
          println(command);
          auto c = command[1].value;
          if (c != "\n")
            {
              history.setFromCursor(cursor, command[2]);
              _insertAtCursor(c[0]);
              history.setFromCursor(cursor, command[0]);
            }
          else
            {
              history.setFromCursor(cursor, command[2]);
              _splitLineAtCursor();
              history.setFromCursor(cursor, command[0]);
            }

          preparePageForRender();
          return;
        }

      println(command);
    }

  inline void save(void)
    {
      if (last_modify_time != file.modify_time())
        { println("WARNING: file modified after opening"); }
      // TODO check for first dirty line to seek and not rewrite pre-dirty segment
      std::string acc;
      for (const auto& line : lines) acc += line + "\n";
      file.overwrite(acc);
    }
};
