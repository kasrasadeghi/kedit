#include "Editor.hpp"

void Editor::handleKey(int key, int scancode, int action, int mods)
  {
    // TODO create new file
    // TODO create new buffer without file ?

    if (GLFW_PRESS == action)
      {
        if (GLFW_KEY_LEFT_CONTROL == key)
          {
            _control_mode = not _control_mode;
          }
      }

    if (_control_mode)
      {
        // control keys are mutually exclusive and toplayer
        if (handleKeyControl(key, scancode, action, mods)) return;
      }

    if (GLFW_RELEASE == action)
      {
        if (GLFW_KEY_LEFT_CONTROL == key && _control_mode_release_exit)
          {
            _control_mode = false;
            _control_mode_release_exit = false;
          }
      }

    // TODO handle modal pages better
    // CONSIDER organization of pages
    // TODO there should be a modal case here

    // TODO massive cleanup

    /// Key Input Handlers ===--------------------------------------------------------------===///

    // modal case
    if (search_common.active)
      {
        if (GLFW_KEY_ESCAPE == key && GLFW_PRESS == action)
          {
            // CONSIDER: clearing query here
            // - maybe also put clearing the query in the history
            search_common.closeSearch();
          }

        search_common.menu.handleKey(key, scancode, action, mods);
        // SOON figure out when the buttons should also go to the underlying filebuffer or menu

        if (_control_mode)
          {
            search_common.menu.handleKeyControl(key, scancode, action, mods);
          }
        else
          {
            search_common.menu.handleKeyEdit(key, scancode, action, mods);
          }

        // TODO fix this, WARNING gross incoming
        // this is a message from the search's edit handling and history handling that we should scan the current page
        // - the only pages that support search are currently filebuffers (jan 13, 2021)
        _handleShouldScan();

        bool fallthrough = GLFW_KEY_UP == key || GLFW_KEY_DOWN == key;
        if (not fallthrough)
          {
            return;
          }
      }

    // active page
    if (Type::FileBufferT == currentPage()->_type)
      {
        currentFileBuffer()->handleKey(key, scancode, action, mods);
      }
    else if (Type::MenuT == currentPage()->_type)
      {
        currentMenu()->handleKey(key, scancode, action, mods);
      }

    // control mode
    if (Type::FileBufferT == currentPage()->_type)
      {
        if (_control_mode)
          {
            // if you press a key while ctrl is held,
            //   releasing ctrl exits control mode
            // TODO: check that the key that is pressed while control is held is not control
            //       (right control, for example)
            if (GLFW_PRESS == action && (GLFW_MOD_CONTROL & mods))
              {
                _control_mode_release_exit = true;
              }
            currentFileBuffer()->handleKeyControl(key, scancode, action, mods);
          }
        else
          currentFileBuffer()->handleKeyEdit(key, scancode, action, mods);
      }

    if (Type::MenuT == currentPage()->_type)
      {
        if (_control_mode)
          {
            currentMenu()->handleKeyControl(key, scancode, action, mods);
          }
        else
          {
            currentMenu()->handleKeyEdit(key, scancode, action, mods);
          }
      }
  }

void Editor::_handleShouldScan()
  {
    if (search_common.should_scan)
      {
        currentFileBuffer()->_search.offset = -1;
        currentFileBuffer()->_search.index = -1;
        search_common.scanAll(currentFileBuffer()->rope, currentFileBuffer()->_search);
        search_common.should_scan = false;
      }
  }

bool Editor::handleKeyControl(int key, int scancode, int action, int mods)
  {
    if (GLFW_PRESS != action) return false;

    if (GLFW_KEY_Q == key)
      {
        _window_close();
      }

    if (GLFW_KEY_D == key)
      {
        ++ _debug_counter;
      }

    if (GLFW_KEY_R == key)
      {
        _debug_counter = 0;
      }

    if (GLFW_KEY_C == key)
      {
        clipboard.kill_ring.push_back(Rope{});

        // consider changing "Type" enum to "PageType"
        if (Type::FileBufferT == currentPage()->_type)
          {
            currentFileBuffer()->copy(clipboard.kill_ring.back());
          }
        return false;
      }

    if (GLFW_KEY_V == key)
      {
        if (Type::FileBufferT == currentPage()->_type)
          {
            currentFileBuffer()->paste(clipboard.kill_ring.back(), clipboard.kill_ring.size() - 1, (void*)(&clipboard));
          }
        return false;
      }

    if (GLFW_KEY_F == key)
      {
        if (Type::FileBufferT == currentPage()->_type)
          {
            _control_mode = false;
            _swallow_char = 1; // TODO maybe increment instead?
            currentFileBuffer()->search(GLFW_MOD_SHIFT & mods);
          }
        return true;
      }

    if (GLFW_KEY_B == key)
      {
        openBrowser();
        return false;
      }

    if (GLFW_KEY_E == key)
      {
        if (_filebuffers.size() != 0)
          openSwap();
        return false;
      }

    // CONSIDER: opening swap menu after closing current file
    // CONSIDER: open file browser/terminal after closing last file
    if (GLFW_KEY_W == key)
      {
        if (_pages.size() > 1)
          freeCurrent();
        return false;
      }
    // CONSIDER: closing file if it is the only one open and opening a menu

    return false;
  }

void Editor::handleChar(unsigned char codepoint)
  {
    if (_swallow_char < 0)
      {
        println("ERROR: negative swallow char state, setting to zero");
        _swallow_char = 0;
        return;
      }

    // only if _swallow_char is zero should we actually handle that char
    if (_swallow_char > 0)
      {
        -- _swallow_char;
        return;
      }

    if (Type::FileBufferT == currentPage()->_type)
      {
        if (search_common.active && not _control_mode)
          {
            // TODO: send codepoint to _search_common ?
            // TODO: send codepoint to _search_common's menu instead of directly to the textfield
            // - the menu should navigate it to the textField
            // SOON
            search_common.menu.handleChar(codepoint);

            _handleShouldScan();
            return;
          }

        if (not _control_mode)
          {
            currentFileBuffer()->handleChar(codepoint);
          }
      }
  }
