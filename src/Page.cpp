#include "Page.hpp"
#include "FileBuffer.hpp"
#include "Menu.hpp"

void Page::render(GraphicsContext& gc)
  {
    switch(_type)
      {
      case Type::FileBufferT:
        ((FileBuffer*)(this))->render(gc);
        break;
      case Type::MenuT:
        ((Menu*)(this))->render(gc);
        break;
      case Type::NoneT:
        println("ERROR: Oh no, you have a NoneT Buffer. "
                "Contact your developer today!");
        break;
      }

    gc.drawRectangle(position, size);
  }


void Page::handleKey(int key, int scancode, int action, int mods)
  {
    switch(_type)
      {
      case Type::FileBufferT:
        ((FileBuffer*)(this))->handleKey(key, scancode, action, mods);
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
