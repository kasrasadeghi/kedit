#pragma once

#include "PageT.hpp"
#include "Buffer.hpp"

#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

// all Pages have a Type from PageT as their first element
// - manual inheritance
struct Page {
  Type _type;
  Buffer* buffer;

  void render(RenderWindow& window, TextRenderer& tr);
  void handleKey(int key, int scancode, int action, int mods);
};
