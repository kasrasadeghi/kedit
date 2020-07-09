#pragma once

#include "Buffer.hpp"
#include "PageT.hpp"
#include "Page.hpp"

#include "Cursor.hpp"

#include <backbone-core-cpp/File.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

#include <string>

struct FileBuffer {
  Page page;

  File file;

  Cursor cursor;

  std::vector<std::string> lines;

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
      file = File::open(file_path);
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

  inline void handleKey(int key, int scancode, int action, int mods)
    {
      // TODO consider synchronization issues with movement keys and text input from CharCallback

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
              if (cursor.column == lines.at(cursor.line).size() && cursor.line < lines.size() - 1)
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

  inline void handleKeyEdit(int key, int scancode, int action, int mods)
    {
      // guards
      if (not cursor.invariant(lines)) return;

      // EDITTING

      if (GLFW_PRESS != action and GLFW_REPEAT != action) return;

      if (GLFW_KEY_BACKSPACE == key)
        {
          if (0 == cursor.column)
            {
              if (0 == cursor.line) return;

              std::string temp = lines.at(cursor.line);
              lines.erase(lines.begin() + cursor.line);
              -- cursor.line;
              lines.at(cursor.line) += temp;
              cursor.column = lines.at(cursor.line).length() - temp.length();
            }

          else
            {
              auto& line = lines.at(cursor.line);
              -- cursor.column;
              line.erase(line.begin() + cursor.column);
            }

          preparePageForRender();
          return;
        }

      if (GLFW_PRESS != action) return;

      if (GLFW_KEY_ENTER == key)
        {
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
              std::string& line = lines.at(cursor.line);
              std::string head = line.substr(0, cursor.column);
              std::string tail = line.substr(cursor.column);

              line = head;
              lines.insert(lines.begin() + cursor.line + 1, tail);
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

      auto& line = lines.at(cursor.line);
      line.insert(line.begin() + cursor.column, codepoint);

      ++ cursor.column;

      preparePageForRender();
    }

};
