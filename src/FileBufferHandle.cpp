#include "FileBuffer.hpp"

void FileBuffer::handleKey(int key, int scancode, int action, int mods)
  {
    if (_search.common->active)
      {
        handleKeySearch(key, scancode, action, mods);
        return;
      }

    if (not (GLFW_PRESS == action || GLFW_REPEAT == action)) return;

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
        return;
      }

    if (GLFW_KEY_END == key)
      {
        Move::endOfLine(cursor, rope);
        return;
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

void FileBuffer::handleKeySearch(int key, int scancode, int action, int mods)
  {
    if (not (GLFW_PRESS == action || GLFW_REPEAT == action)) return;

    if (GLFW_KEY_LEFT == key || GLFW_KEY_P == key)
      {
        if (0 == _search.index)
          {
            _search.index = _search.results.size() - 1;
          }
        else
          {
            -- _search.index;
          }
        cursor = _search.results.at(_search.index);
        if (_search.offset != (size_t)-1) cursor.column += _search.offset;
        return;
      }

    if (GLFW_KEY_RIGHT == key || GLFW_KEY_N == key)
      {
        if (_search.results.size() - 1 == _search.index)
          {
            _search.index = 0;
          }
        else
          {
            ++ _search.index;
          }
        cursor = _search.results.at(_search.index);
        if (_search.offset != (size_t)-1) cursor.column += _search.offset;
        return;
      }

    // TODO change to ESC, make quit something else
    if (GLFW_KEY_ENTER == key)
      {
        // TODO erase cursor backup
        _search.common->active = false;
        // TODO clear index and offsets
        return;
      }
  }

void FileBuffer::handleKeyEdit(int key, int scancode, int action, int mods)
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

void FileBuffer::handleChar(unsigned int codepoint)
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

void FileBuffer::handleKeyControl(int key, int scancode, int action, int mods)
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
