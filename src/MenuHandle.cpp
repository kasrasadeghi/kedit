#include "Menu.hpp"

void Menu::handleKey(int key, int scancode, int action, int mods)
  {
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
        }

        if ("textfield" == command_set.value) {
          // unimplemented
        }
        return;
      }
  }

void Menu::handleChar(unsigned char codepoint)
  {
    print("what: ", codepoint);
  }
