#include "Cursor.hpp"
#include "Rope.hpp"

#include <cassert>

namespace Move {
  inline void _cursorMoveToEndOfLine(Cursor& cursor, const Rope& rope)
    {
      cursor.column = rope.linelength(cursor);
    }

  inline void _correctCursorPastEndOfLine(Cursor& cursor, const Rope& rope)
    {
      if (rope.lines.at(cursor.line).length() < cursor.column)
        {
          _cursorMoveToEndOfLine(cursor, rope);
        }
    }

  /// NOTE: returns false when the cursor fails to move
  inline bool left(Cursor& cursor, const Rope& rope)
    {
      if (cursor.column != 0)
        {
          -- cursor.column;
          return true;
        }

      assert(cursor.column == 0);
      // column zero, roll to previous line

      if (cursor.line != 0)
        {
          -- cursor.line;
          _cursorMoveToEndOfLine(cursor, rope);
          return true;
        }
      else
        {
          return false;
        }
    }

  inline bool right(Cursor& cursor, const Rope& rope)
    {
      if (cursor.column < rope.linelength(cursor))
        {
          ++ cursor.column;
          return true;
        }

      assert(cursor.column == rope.linelength(cursor));

      // roll over to next line
      if (cursor.line < rope.lines.size() - 1)
        {
          ++ cursor.line;
          cursor.column = 0;
          return true;
        }
      else
        {
          return false;
        }
    }

  inline bool up(Cursor& cursor, const Rope& rope)
    {
      if (cursor.line == 0)
        { return false; }

      -- cursor.line;
      _correctCursorPastEndOfLine(cursor, rope);
      return true;
    }

  inline bool down(Cursor& cursor, const Rope& rope)
    {
      if (cursor.line == rope.lines.size() - 1)
        { return false; }

      ++ cursor.line;
      _correctCursorPastEndOfLine(cursor, rope);
      return true;
    }
}
