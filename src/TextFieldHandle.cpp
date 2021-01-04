#include "TextField.hpp"
#include <kgfx/RenderWindow.hpp>

// TODO gather common editor functionality between filebuffer and textfield in one common area

void TextField::handleKey(int key, int scancode, int action, int mods)
  {
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
  }

/// returns true if rope has been modified
bool TextField::handleKeyEdit(int key, int scancode, int action, int mods)
  {
    // guards
    if (not cursor.invariant(rope.lines)) return false;


    if (GLFW_PRESS != action and GLFW_REPEAT != action) return false;

    if (GLFW_KEY_BACKSPACE == key)
      {
        history.push("backspace");
        history.addCursor(cursor, "before-cursor");

        if (Move::left(cursor, rope))
          { history.add(str(rope.chardelete(cursor))); }
        else
          { history.pop(); return false; }

        return true;
      }

    if (GLFW_KEY_DELETE == key)
      {
        history.push("delete");
        history.addCursor(cursor, "before-cursor");

        if (char c = rope.chardelete(cursor); c != '\0')
          { history.add(str(c)); }
        else
          { history.pop(); return false; }

        return true;
      }
  }

void TextField::handleKeyControl(int key, int scancode, int action, int mods)
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

    if (GLFW_KEY_SPACE == key)
      {
        // drop shadow cursor
        shadow_cursor = cursor;
        // CONSIDER: two shadow cursors for direct buffer to buffer yanks
        // TODO: move shadow cursor when region resizes to not allow for that shape
        // TODO: move shadow cursor when text is deleted before the shadow cursor
      }
  }

bool TextField::handleChar(unsigned int codepoint)
  {
    if (not cursor.invariant(rope.lines)) return false;

    history.push("char");
    history.addCursor(cursor, "before-cursor");
    history.add(str((char)codepoint));

    rope.insert((char)codepoint, cursor);

    ++ cursor.column;

    return true;
  }
