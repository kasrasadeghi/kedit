#pragma once

#include "Buffer.hpp"

#include <backbone-core-cpp/File.hpp>
#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/Str.hpp>

#include <string>

// like buffer, but with interactive options
struct Menu {

  ///=============/ Members /=========================================///
  Buffer buffer; // refers to _repr_alloc

  Texp _layout;
  std::string _repr_alloc;  // layout.tabs() stored into a std::string

  uint64_t cursor; // 0 .. selectable_lines.size() - 1

  std::vector<uint64_t> selectable_lines;

  // map from selection to command;
  std::vector<Texp> commands;

  using FunctionTable = std::unordered_map<std::string, std::function<void(const Texp&)>>;
  FunctionTable _function_table;

  /** Initialization Overview
   *
   * _layout is set from the owner
   *
   * Owner calls .setHandlers() with a function table
   * - sets _function_table, which is used to handle selection events from the menu's buttons
   *
   * Owner calls .parseLayout(_layout)
   * - zeros .cursor and clears .selectable_lines and .commands
   * - calls _createMenuRepr()
   *   - _createMenuRepr is recursive, traverses elements of layout
   *   - populates .selectable_lines and .commands
   * - creates .rope
   */

  ///=============/ Methods /=========================================///

  inline void setHandlers(FunctionTable function_table)
    {
      _function_table = function_table;
    }

  inline void handleKey(int key, int scancode, int action, int mods)
    {
      if (GLFW_PRESS == action)
        {
          if (GLFW_KEY_UP == key && cursor != 0)
            {
              -- cursor;
              return;
            }

          if (GLFW_KEY_DOWN == key && cursor < selectable_lines.size() - 1)
            {
              ++ cursor;
              return;
            }

          if (GLFW_KEY_ENTER == key)
            {
              auto& curr_command = commands[cursor];
              auto& handler = _function_table.at(curr_command.value);
              handler(curr_command[0]);
              return;
            }
        }
    }


  // similar, but not inherited from Buffer::render
  // TODO merge this and Buffer's render(). ideas:
  // - pass a lambda for a line handler
  // - add bold to rope sections
  inline void render(RenderWindow& window, TextRenderer& tr)
    {
      uint64_t line_number = 0;

      for (size_t i = 0; i < buffer.contents.lines.size(); ++i)
        {
          StringView line = buffer.contents.lines[i];

          double xpos = 200;
          double current_offset = (30 * buffer.line_scroller.position);
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

  /// NOTE: currently expects this->layout as the argument
  inline void parseLayout(const Texp& layout)
    {
      // create cursor areas
      this->cursor = 0;
      commands.clear();
      selectable_lines.clear();

      // create menu representation texp
      uint64_t curr_line = 0;
      Texp repr = _createMenuRepr(layout, curr_line);

      // render texp to rope
      _repr_alloc = repr.tabs();
      buffer.contents.make(_repr_alloc);
      buffer.line_scroller.reset();
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

          _addCommand(curr_line, layout[1]);
          return result;
        }

      assert(false && "layout element type is not matched");
      exit(1);
    }

  inline void _addCommand(const uint64_t line_number, const Texp& command)
    {
      selectable_lines.push_back(line_number);
      commands.push_back(command);
    }
};
