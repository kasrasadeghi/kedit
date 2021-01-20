#include "Menu.hpp"

void Menu::handleKey(int key, int scancode, int action, int mods)
  {
    if (not invariant())
      {
        println("ERROR: menu invariant failed when handling key");
        return;
      }

    // SOON: send key events to selected textfield
    // CONSIDER: having a default textfield
    // - or to transition focus to the most recently selected/edited textfield

    // === CURSOR MOVEMENT ================================

    if (not (GLFW_PRESS == action || GLFW_REPEAT == action)) return;

    // CONSIDER: making up and down modulo
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

    if (GLFW_KEY_PAGE_UP == key)
      {
        cursor = 0;
        return;
      }

    if (GLFW_KEY_PAGE_DOWN == key)
      {
        cursor = selectable_lines.size() - 1;
        return;
      }


    // === SELECTION AND EVENT HANDLERS  ================================

    if (not (GLFW_PRESS == action)) return;

    if (GLFW_KEY_ENTER == key)
      {
        const Texp& command_set = commands[cursor];

        // (button (press ('key argument)))
        if ("button" == command_set.value) {
          auto& press_command = command_set.must_find("press")[0];

          auto& handler = _function_table.at(press_command.value);
          handler(press_command[0]);
          return;
        }

        // (textfield (change ('key1 [arg1])) (submit ('key2 [arg2])))
        if ("textfield" == command_set.value) {
          auto& submit_command = command_set.must_find("submit")[0];

          auto& handler = _function_table.at(submit_command.value);

          // get value of current textfield
          auto line_number = selectable_lines[cursor];
          TextField& tf = textfields.at(line_number);

          auto quote = [](std::string s) -> std::string
                       { return "\"" + s + "\""; };

          auto content = quote(tf.string());

          handler(Texp{content, {submit_command[0]}});
          return;
        }
      }

    // SOON probably send events to the current textfield if the current is a textfield
    if ("textfield" == commands[cursor].value)
      {
        textfields.at(selectable_lines[cursor]).handleKey(key, scancode, action, mods);
        return;
      }
  }


void Menu::handleKeyEdit(int key, int scancode, int action, int mods)
  {
    if ("textfield" == commands[cursor].value)
      {
        TextField& tf = textfields.at(selectable_lines[cursor]);
        auto before_content = tf.string();

        // edit
        tf.handleKeyEdit(key, scancode, action, mods);
        auto after_content = tf.string();

        if (before_content != after_content)
          {
            const Texp& command_set = commands[cursor];
            auto& change_command = command_set.must_find("change")[0];
            auto& handler = _function_table.at(change_command.value);

            auto quote = [](std::string s) -> std::string
                         { return "\"" + s + "\""; };

            auto content = quote(tf.string());
            handler(Texp{content, {change_command[0]}});
          }
      }
  }

void Menu::handleKeyControl(int key, int scancode, int action, int mods)
  {
     if ("textfield" == commands[cursor].value)
      {
        TextField& tf = textfields.at(selectable_lines[cursor]);
        auto before_content = tf.string();

        // control
        tf.handleKeyControl(key, scancode, action, mods);
        auto after_content = tf.string();

        if (before_content != after_content)
          {
            const Texp& command_set = commands[cursor];
            auto& change_command = command_set.must_find("change")[0];
            auto& handler = _function_table.at(change_command.value);

            auto quote = [](std::string s) -> std::string
                         { return "\"" + s + "\""; };

            auto content = quote(tf.string());
            handler(Texp{content, {change_command[0]}});
          }
      }
  }

void Menu::handleChar(unsigned char codepoint)
  {
    const Texp& command_set = commands[cursor];
    if ("textfield" == command_set.value) {
      auto& change_command = command_set.must_find("change")[0];

      auto& handler = _function_table.at(change_command.value);

      auto line_number = selectable_lines[cursor];
      TextField& tf = textfields.at(line_number);

      tf.handleChar(codepoint);

      auto quote = [](std::string s) -> std::string
                   { return "\"" + s + "\""; };

      auto content = quote(tf.string());

      handler(Texp{content, {change_command[0]}});
    }
  }
