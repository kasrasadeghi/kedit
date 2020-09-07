#pragma once

#include "Rope.hpp"
#include "Cursor.hpp"

#include <string>
#include <vector>

struct Search {
  std::string query = "";

  inline void scanAll(const Rope& rope, std::vector<Cursor>& output_cursors)
    {
      assert(query != "");

      for (size_t line_i = 0; line_i < rope.lines.size(); ++line_i)
        {
          const auto& line = rope.lines.at(line_i);

          size_t result = line.find(query);
          while (result != std::string::npos)
            {
              output_cursors.push_back(Cursor{line_i, result});
              result = line.find(query, result + 1);
            }
        }
      println("done");
    }
};
