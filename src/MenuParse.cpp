#include "Menu.hpp"

void Menu::setHandlers(FunctionTable function_table)
  {
    _function_table = function_table;
  }

/// NOTE: currently expects this->layout as the argument
void Menu::parseLayout(const Texp& layout)
  {
    // create cursor areas
    this->cursor = 0;
    commands.clear();
    selectable_lines.clear();

    // create menu representation texp
    uint64_t curr_line = 0;
    Texp repr = _createMenuRepr(layout, curr_line);

    // commands is bijective to selectable_lines, they both use cursor input
    assert(commands.size() == selectable_lines.size());

    // render texp to rope
    _repr_alloc = repr.tabs();
    page.buffer.contents.make(_repr_alloc);
    page.buffer.line_scroller.reset();
  }

Texp Menu::_createMenuRepr(const Texp& layout, uint64_t& curr_line)
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
    // =>
    // value
    //   child0
    //   ...
    if ("text" == layout.value)
      {

        // increment value before children
        ++ curr_line;

        //              v- skip text's value
        for (size_t i = 1; i < layout.size(); ++i)
          {
            auto& child = layout[i];
            result.push(_createMenuRepr(child, curr_line));
          }

        return result;
      }

    // (button "value" (on (press <cmd>)))
    if ("button" == layout.value)
      {
        Texp command = layout[1];
        command.value = "button";
        _addCommand(curr_line, command);

        // increment value after finishing making button
        ++ curr_line;

        return result;
      }

    // TODO this value is ignored? maybe useful for hint, starting value, or default value?
    // - maybe also a label, like "search: [    ]"
    // (textfield "value" (on (change <cmd>) (submit <cmd>)))
    if ("textfield" == layout.value)
      {
        Texp command = layout[1];
        command.value = "textfield";
        _addCommand(curr_line, command);
        _addTextField(curr_line);

        // increment value after finishing making textfield
        ++ curr_line;

        return result;
      }

    assert(false && "layout element type is not matched");
    exit(1);
  }

void Menu::_addCommand(const uint64_t line_number, const Texp& command)
  {
    // TODO grammatical validation of command structure

    selectable_lines.push_back(line_number);
    commands.push_back(command);
  }

void Menu::_addTextField(const uint64_t line_number)
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
