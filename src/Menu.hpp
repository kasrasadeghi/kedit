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
  void render(GraphicsContext& gc);

  /// MenuParse ===---------------------------------------------------------------------===///

  void setHandlers(FunctionTable function_table);

  /// NOTE: currently expects this->layout as the argument
  void parseLayout(const Texp& layout);
  Texp _createMenuRepr(const Texp& layout, uint64_t& curr_line);
  void _addCommand(const uint64_t line_number, const Texp& command);
  void _addTextField(const uint64_t line_number);

  /// Interaction ===-------------------------------------------------------------------===///

  void handleKey(int key, int scancode, int action, int mods);
  void handleKeyEdit(int key, int scancode, int action, int mods);
  void handleKeyControl(int key, int scancode, int action, int mods);
  void handleChar(unsigned char codepoint);
};
