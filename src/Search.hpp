#pragma once

#include "Rope.hpp"
#include "Cursor.hpp"
#include "Menu.hpp"
#include "GraphicsContext.hpp"

#include <string>
#include <vector>


struct SearchCommon;

/// the search element within a page necessary to interface with the search interface
/// - currently only used by FileBuffer
struct Search {
  SearchCommon* common = nullptr;

  size_t index = 0;  // TODO: build data structure for easily cycle-able vector, like a ring/ringbuffer/deque
  size_t offset = -1;

  // search results are in increasing order
  std::vector<Cursor> results;
};



/// the search element of the Editor, in global scope
struct SearchCommon {
  Menu menu;
  std::string _query = "";  // CURRENT, maybe replace this with something that observes the textfield in the search menu
  bool active = false;

  // true to communicate to the editor that the current page should scan
  // - TODO only currently works for filebuffers
  bool should_scan = false; // TODO FIXME this is gross, please fix

  inline void setQuery(std::string query)
    {
      this->_query = query;
      // NOTE: textfield is on first line of menu
      menu.textfields[0].setContent(query);
    }

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

      // TODO index should be set to the first location that is beyond(/before?) the current cursor

      Menu::FunctionTable function_table {
        {{"search-change", [&](const Texp& arg) {
                             auto unquote = [](std::string s) -> std::string
                                            { return s.substr(1, s.length() - 2); };

                             // NOTE: this doesn't need to use setQuery because
                             //       the menu should have reacted to the change already
                             this->_query = unquote(arg.value);
                             if ("" != this->_query)
                               {
                                 this->should_scan = true;
                               }

                             // CONSIDER: messaging editor to clear results somehow?
                           }},
         {"search-submit", [&](const Texp& arg) {
                             // TODO consider shouldreset
                             // - should_reset would tell the editor that the filebuffer's search
                             //   component should reset the index and all that
                             closeSearch();
                           }},
        }
      };

      menu.setHandlers(function_table);
      menu.parseLayout(menu._layout);
    }

  inline void initGraphics(GraphicsContext& gc)
    {
      // TODO do this only once, not every frame
      // - need access to the graphics context
      auto& tl     = menu.page.top_left_position;
      auto& offset = menu.page.offset;
      auto& size   = menu.page.size;

      auto SL = 300; // search box length
      offset = {gc.line_height, gc.line_height};
      tl = {1800 - SL, 150};
      size = {SL, 1.5 * gc.line_height};
    }

  inline void scanAll(const Rope& rope, Search& search)
    {
      search.results.clear();

      assert(this->_query != "");

      for (size_t line_i = 0; line_i < rope.lines.size(); ++line_i)
        {
          const auto& line = rope.lines.at(line_i);

          size_t result = line.find(this->_query);
          while (result != std::string::npos)
            {
              search.results.push_back(Cursor{line_i, result});
              result = line.find(this->_query, result + 1);
            }
        }

      active = true;
    }

  inline void closeSearch(void)
    {
      this->active = false;
      this->should_scan = false;
    }
};
