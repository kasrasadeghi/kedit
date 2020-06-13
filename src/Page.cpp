#include "Page.hpp"
#include "FileBuffer.hpp"
#include "Menu.hpp"

void Page::render(RenderWindow& window, TextRenderer& tr)
  {
    switch(_type)
      {
      case Type::FileBufferT:
        ((FileBuffer*)(this))->render(window, tr);
        break;
      case Type::MenuT:
        ((Menu*)(this))->render(window, tr);
        break;
      case Type::NoneT:
        println("ERROR: Oh no, you have a NoneT Buffer. "
                "Contact your developer today!");
        break;
      }
  }


void Page::handleKey(int key, int scancode, int action, int mods)
  {
    switch(_type)
      {
      case Type::FileBufferT:
        // ((FileBuffer*)(this))->handleKey(key, scancode, action, mods);
        break;
      case Type::MenuT:
        ((Menu*)(this))->handleKey(key, scancode, action, mods);
        break;
      case Type::NoneT:
        println("ERROR: Oh no, you have a NoneT Buffer. "
                "Contact your developer today!");
        break;
      }
  }
