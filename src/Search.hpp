#pragma once

#include "Rope.hpp"
#include "Cursor.hpp"
#include "Menu.hpp"

#include <string>
#include <vector>


struct SearchCommon;

/// the search element within a page necessary to interface with the search interface
/// - currently only used by FileBuffer
struct Search {
  SearchCommon* common = nullptr;

  size_t index = 0;  // TODO: build data structure for easily cycle-able vector, like a ring/ringbuffer/deque
  size_t offset = -1;
  std::vector<Cursor> results;
};

/// the search element of the Editor, in global scope
struct SearchCommon {
  Menu menu;
  std::string query = "";
  bool active = false;

  inline void scanAll(const Rope& rope, Search& search)
    {
      search.results.clear();

      assert(query != "");

      for (size_t line_i = 0; line_i < rope.lines.size(); ++line_i)
        {
          const auto& line = rope.lines.at(line_i);

          size_t result = line.find(query);
          while (result != std::string::npos)
            {
              search.results.push_back(Cursor{line_i, result});
              result = line.find(query, result + 1);
            }
        }

      active = true;
    }
};
