#pragma once

// TODO ensure compatibility with backbone cursor
// TODO move to backbone-core-cpp

#include <ostream>

struct Cursor {
  uint64_t line = 0; // cursor can go one past the last character to append to the line
  uint64_t column = 0;

  inline bool invariant(const std::vector<std::string>& lines)
    {
      if (not check_line_bounds(lines)) return false;

      auto& current_line = lines.at(line);
      if (column > current_line.length())
        {
          println("ERROR: cursor column not within current line length");
          return false;
        }

      return true;
    }

  inline bool check_line_bounds(const std::vector<std::string>& lines)
    {
      if (line >= lines.size())
        {
          println("ERROR: cursor line number '", line, "' not within document of line count '", lines.size(),"'");
          return false;
        }

      return true;
    }

  inline friend std::ostream& operator<<(std::ostream& o, const Cursor& cursor)
    {
      return o << "cursor(" << cursor.line << "," << cursor.column << ")";
    }
};
