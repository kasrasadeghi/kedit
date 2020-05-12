#pragma once

#include <backbone-core-cpp/StrView.hpp>

#include <vector>

/// Rope
//
// not actually a rope
// normal rope = bst of strings
//
// this is a vector of StringViews
//
// future ideas:
// - deque of string
// - n-ary trees of string
struct Rope {
  std::vector<StringView> lines;

  inline void make(const StringView text)
    {
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
};
