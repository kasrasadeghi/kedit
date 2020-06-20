#pragma once

#include "PageT.hpp"
#include "Buffer.hpp"
#include "GraphicsContext.hpp"

#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

// all Pages have a Type from PageT as their first element
// - manual inheritance
struct Page {
  Type _type = Type::NoneT;
  Buffer* buffer;

  glm::vec2 position = {100, 100};
  glm::vec2 size = {1000, 1000};

  void render(GraphicsContext& gc);
  void handleKey(int key, int scancode, int action, int mods);
};
