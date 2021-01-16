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
  std::string query = "";  // CURRENT, maybe replace this with something that observes the textfield in the search menu
  bool active = false;

  // true to communicate to the editor that the current page should scan
  // - TODO only currently works for filebuffers
  bool should_scan = false; // TODO FIXME this is gross, please fix


  inline void init()
    {
      menu.page._type = Type::MenuT;

      Texp& root = menu._layout;
      root = Texp("textfield", {Texp("\"search query\"")});

      auto change = Texp{"change", {Texp{"search-change", {Texp("unused-arg")}}}};
      auto submit = Texp{"submit", {Texp{"search-submit", {Texp("unused-arg")}}}};

      auto command = Texp("on");
      command.push(change);
      command.push(submit);

      root.push(command);

      // CURRENT

      // TODO index should be set to the first location that is beyond the current cursor

      Menu::FunctionTable function_table {
        {{"search-change", [&](const Texp& arg) {
                             auto unquote = [](std::string s) -> std::string
                                            { return s.substr(1, s.length() - 2); };

                             this->query = unquote(arg.value);
                             if ("" != this->query)
                               {
                                 this->should_scan = true;
                               }
                           }},
         {"search-submit", [&](const Texp& arg) {
                             this->query = "";
                             this->should_scan = false;
                             // TODO consider shouldreset
                             // - should_reset would tell the editor that the filebuffer's search
                             //   component should reset the index and all that
                             active = false;
                           }},
        }
      };

      menu.setHandlers(function_table);
      menu.parseLayout(menu._layout);
    }

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
