#pragma once

#include "Cursor.hpp"

#include <backbone-core-cpp/StrView.hpp>

#include <vector>

// None of these are actually a Rope, which is a binary tree of strings.
// Efficient use of a classic Rope with copy-on-write and reference
// counting for garbage collection requires more machinery, and will be
// implemented when that much optimization is needed for this data structure.

/// ViewRope
//
// not actually a rope
// normal rope = bst of strings
//
// this is a vector of StringViews
//
// future ideas:
// - deque of string
// - n-ary trees of string
struct ViewRope {
  std::vector<StringView> lines;

  inline void make(const StringView text)
    {
      lines.clear();

      char* char_iter = text._data;
      while (char_iter < text.end())
        {
          // chomp a line into acc
          StringView acc {char_iter, 1};
          while (char_iter < text.end() && *char_iter != '\n')
            {
              ++ acc._length;
              ++ char_iter;
            }

          // remove the newline, '\n'
          -- acc._length;

          lines.push_back(acc);
          ++ char_iter;
        }
    }

  inline size_t length(void)
    {
      size_t acc = 0;
      for (auto l : lines)
        {
          acc += l._length;
        }
      return acc;
    }
};


struct Rope {
  std::vector<std::string> lines;

  /// get area between begin cursor and end cursor
  inline void make(const Rope& other, Cursor begin, Cursor end)
    {
      lines.clear();

      if (end < begin) std::swap(begin, end);

      if (begin.line == end.line)
        {
          std::string selection = other.lines.at(begin.line).substr(begin.column, end.column - begin.column);
          lines.push_back(selection);
          return;
        }

      // begin.line != end.line

      // copy chunk til end of line of first line in selection
      auto first_chunk = other.lines.at(begin.line).substr(begin.column);
      lines.push_back(first_chunk);

      for (size_t i = begin.line + 1; i <= end.line - 1; ++i)
        {
          lines.push_back(other.lines.at(i));
        }

      auto last_chunk = other.lines.at(end.line).substr(0, end.column);
      lines.push_back(last_chunk);
      // NOTE: if end.column == 0 then last_chunk is ""
    }

  /// breaks a line into two at a cursor
  //
  // NOTE: not split, split makes 2 ropes
  inline void linebreak(Cursor cursor)
    {
      std::string& line = lines.at(cursor.line);
      std::string head = line.substr(0, cursor.column);
      std::string tail = line.substr(cursor.column);

      line = head;
      lines.insert(lines.begin() + cursor.line + 1, tail);
    }
};
