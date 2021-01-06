
#pragma once

#include "Buffer.hpp"
#include "PageT.hpp"
#include "Page.hpp"
#include "TextField.hpp"

#include <backbone-core-cpp/File.hpp>
#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/Str.hpp>

#include <string>

// like buffer, but with interactive options
struct Menu {

  ///=============/ Members /=========================================///
  Page page;

  std::string name;

  Texp _layout;
  std::string _repr_alloc;  // layout.tabs() stored into a std::string

  // map from selection index to command structure
  // - command structures are different shapes depending on their type, e.g. button or textfield
  //
  //   legend (based on type of selection):
  //
  // (button "value" (on (press ('key <argument>))))
  // ->
  // (button (press ('key <argument>)))
  //   ENTER ->
  //     handler = _function_table[key];
  //     handler(argument)
  //
  // (textfield "value" (on (change ('key1 [arg1])) (submit ('key2 [arg2]))))
  // ->
  // (textfield (change ('key1 [arg1])) (submit ('key2 [arg2])))
  //   ENTER -> /* submit */
  //     handler = _function_table[key2]
  //     handler({value, {arg2}})
  //   SCAN EVENT -> /* change */
  //     handler = _function_table[key1]
  //     handler({value, {arg1}})

  // consider restructuring cursor, selection, and element redirection logic
  uint64_t cursor; // an index of selectable_lines, in [0 .. selectable_lines.size() - 1]
  std::vector<uint64_t> selectable_lines;
  std::vector<Texp> commands; // each selectable line has a command

  // map from cursor (i.e. selectable index) to TextFields
  std::unordered_map<uint64_t, TextField> textfields; // some selectable lines have textfields

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

  // similar, but not inherited from Buffer::render
  // TODO merge this and Buffer's render(). ideas:
  // - pass a lambda for a line handler
  // - add bold to rope sections
  inline void render(GraphicsContext& gc)
    {
      double xpos = page.top_left_position.x + page.offset.x;
      double ypos = page.top_left_position.y + page.offset.y;

      for (size_t line_i = 0; line_i < page.buffer.contents.lines.size(); ++line_i)
        {
          StringView line = page.buffer.contents.lines.at(line_i);

          // TODO make text render clip off viewable area
          double current_offset = (gc.line_height * page.buffer.line_scroller.position);
          double curr_ypos = current_offset + (ypos + (gc.line_height * line_i));

          if (curr_ypos < (uint64_t)(gc.window->height() + gc.line_height) && curr_ypos > (uint64_t)(0))
            {
              if (not selectable_lines.empty() && line_i == this->selectable_lines[this->cursor])
                {
                  gc.text(line, xpos, curr_ypos, glm::vec4(1, 1, 1, 1));
                }
              else
                {
                  gc.text(line, xpos, curr_ypos, glm::vec4(0.7, 0.7, 0.7, 1));
                }
            }
        }
    }

  inline void setHandlers(FunctionTable function_table)
    {
      _function_table = function_table;
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
      page.buffer.contents.make(_repr_alloc);
      page.buffer.line_scroller.reset();
    }

  inline Texp _createMenuRepr(const Texp& layout, uint64_t& curr_line)
    {
      const auto& value = layout[0].value;

      auto unquote = [](std::string s) -> std::string
                     { return s.substr(1, s.length() - 2); };

      Texp result { unquote(value) };

      // TODO support elements with multiline values
      // TODO support line-wrap for long values

      // TODO support: tabs, text views, process FIFOs, text entry

      // NOTE: the elements are responsible for incrementing line number themselves
      // - do not increment for the lines of your children

      // legend:
      // "value" - means quoted string value
      // (* children) - means a text with other elements as children, must recursively call this function
      // <child> - means a command in the shape of a texp, should call "_addCommand"
      // [child] - means a texp that is extracted with the meta-binding "child"
      // ('key ... ) - is a texp with a value that is used, but is not literally some text value
      //   as opposed to: (button ... )
      //     which is a texp with a value that is expected to literally be the unquoted string "button"
      //
      // <cmd> is a child that specifically looks like ('key argument))
      //   where [key] is a function and it expects to be passed <argument>

      // (text "value" (* children))
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

      // (button "value" (on (press <cmd>)))
      if ("button" == layout.value)
        {
          ++ curr_line;

          Texp command = layout[1];
          command.value = "button";
          _addCommand(curr_line, command);
          return result;
        }

      // TODO this value is ignored? maybe useful for hint, starting value, or default value?
      // - maybe also a label, like "search: [    ]"
      // (textfield "value" (on (change <cmd>) (submit <cmd>)))
      if ("textfield" == layout.value)
        {
          ++ curr_line;

          Texp command = layout[1];
          command.value = "textfield";
          _addCommand(curr_line, command);
          _addTextField(curr_line);
          return result;
        }

      assert(false && "layout element type is not matched");
      exit(1);
    }

  inline void _addCommand(const uint64_t line_number, const Texp& command)
    {
      // TODO grammatical validation of command structure

      selectable_lines.push_back(line_number);
      commands.push_back(command);
    }

  inline void _addTextField(const uint64_t line_number)
    {
      TextField tf;

      // tf.setContent(value);
      // CONSIDER having each of the following for textfields:
      // - a default value (used when the textfield is empty, but discarded on modification)
      // - a hint string
      // - a starting value (the initial value of the textfield, not discarded on any modification)

      tf.setContent("");
      textfields.insert({line_number, tf});
    }

  /// Interaction ===-------------------------------------------------------------------===///

  void handleKey(int key, int scancode, int action, int mods);
  void handleChar(unsigned char codepoint);
};
