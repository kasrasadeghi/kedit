#pragma once

#include "Rope.hpp"
#include "Scroller.hpp"

#include <backbone-core-cpp/File.hpp>
#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/Str.hpp>

#include <string>

// like buffer, but with interactive options
struct Menu {
  Texp _layout;

  std::string _repr_alloc;  // layout.tabs() stored into a std::string
  Rope rope; // refers to _layout_alloc

  // TODO fix segfault for scrolling on menus
  Scroller line_scroller;
  uint64_t cursor;

  std::vector<uint64_t> selectable_lines;

  // map from selection to command;
  std::vector<std::string> commands;

  inline void _addCommand(const uint64_t line_number, const std::string command)
    {
      selectable_lines.push_back(line_number);
      commands.push_back(command);
    }

  inline void tick(double delta_time)
    { line_scroller.tick(delta_time); }

  inline void render(RenderWindow& window, TextRenderer& tr)
    {
      uint64_t line_number = 0;

      for (size_t i = 0; i < rope.lines.size(); ++i)
        {
          StringView line = rope.lines[i];

          double xpos = 200;
          double current_offset = (30 * line_scroller.position);
          double ypos = current_offset + (50 + (30 * line_number));

          // TODO "+ 30" should be "+ text_height"
          if (ypos < (uint64_t)(window.height() + 30) && ypos > (uint64_t)(0))
            {
              if (i == this->selectable_lines[this->cursor])
                {
                  tr.renderText(line.stringCopy(), 200, ypos, 1, glm::vec4(1, 1, 1, 1));
                }
              else
                {
                  tr.renderText(line.stringCopy(), 200, ypos, 1, glm::vec4(0.7, 0.7, 0.7, 1));
                }
            }
          ++ line_number;
        }
    }

  inline void parseLayout(const Texp& layout)
    {
      // create cursor areas
      this->cursor = 0;

      // create menu representation texp
      uint64_t curr_line = 0;
      Texp repr = _createMenuRepr(layout, curr_line);

      // render texp to rope
      _repr_alloc = repr.tabs();
      rope.make(_repr_alloc);
    }

  inline Texp _createMenuRepr(const Texp& layout, uint64_t& curr_line)
    {
      const auto& value = layout[0].value;
      Texp result {value.substr(1, value.length() - 2)};

      // TODO support elements with multiline values
      // TODO support line-wrap for long values

      // NOTE: the elements are responsible for incrementing line number themselves
      // - do not increment for the lines of your children

      // (text "value" children...)
      if ("text" == layout.value)
        {
          //              v- skip text's value
          for (size_t i = 1; i < layout.size(); ++i)
            {
              auto& child = layout[i];
              result.push(_createMenuRepr(child, curr_line));
            }

          ++ curr_line;
          return result;
        }

      // (button "value" "cmd")
      if ("button" == layout.value)
        {
          ++ curr_line;

          _addCommand(curr_line, layout.value);
          return result;
        }

      assert(false && "layout element type is not matched");
    }
};
