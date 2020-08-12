#pragma once

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
};
