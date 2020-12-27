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
        handleKeyControl(key, scancode, action, mods);
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

    /// Key Input Handlers ===--------------------------------------------------------------===///

    if (Type::FileBufferT == currentPage()->_type)
      {
        currentFileBuffer()->handleKey(key, scancode, action, mods);
      }
    else if (Type::MenuT == currentPage()->_type)
      {
        currentMenu()->handleKey(key, scancode, action, mods);
      }

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
  }

void Editor::handleKeyControl(int key, int scancode, int action, int mods)
  {
    if (GLFW_PRESS != action) return;

    if (GLFW_KEY_C == key)
      {
        clipboard.kill_ring.push_back(Rope{});

        // consider changing "Type" enum to "PageType"
        if (Type::FileBufferT == currentPage()->_type)
          {
            currentFileBuffer()->copy(clipboard.kill_ring.back());
          }
        return;
      }

    if (GLFW_KEY_V == key)
      {
        if (Type::FileBufferT == currentPage()->_type)
          {
            currentFileBuffer()->paste(clipboard.kill_ring.back(), clipboard.kill_ring.size() - 1, (void*)(&clipboard));
          }
        return;
      }

    if (GLFW_KEY_F == key)
      {
        if (Type::FileBufferT == currentPage()->_type)
          {
            currentFileBuffer()->search(GLFW_MOD_SHIFT & mods);
          }
        return;
      }

    if (GLFW_KEY_B == key)
      {
        openBrowser();
        return;
      }

    if (GLFW_KEY_E == key)
      {
        if (_filebuffers.size() != 0)
          openSwap();
        return;
      }

    // CONSIDER: opening swap menu after closing current file
    // CONSIDER: open file browser/terminal after closing last file
    if (GLFW_KEY_W == key)
      {
        if (_pages.size() > 1)
          freeCurrent();
        return;
      }

    // CONSIDER: closing file if it is the only one open and opening a menu
  }

void Editor::handleChar(unsigned char codepoint)
  {
    if (Type::FileBufferT == currentPage()->_type)
      {
        if (not _control_mode)
          {
            currentFileBuffer()->handleChar(codepoint);
          }
      }
  }
