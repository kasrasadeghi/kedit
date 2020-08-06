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
  Buffer buffer;

  inline static glm::vec2 offset = {50, 50};
  glm::vec2 top_left_position = {100, 100};
  glm::vec2 size = {1000, 1000};

  void render(GraphicsContext& gc);
  void handleKey(int key, int scancode, int action, int mods);

  glm::vec2 lineCoord(GraphicsContext& gc, Cursor c)
    {
      float tlx = top_left_position.x
                + offset.x;

      float tly = top_left_position.y
                + offset.y
                + (gc.line_height * c.line)
                + (-(0.8 * gc.line_height))  // start at top of line, 0.8*line_height = line_middle - baseline
                + (gc.line_height * buffer.line_scroller.position);  // add scroll offset

      return glm::vec2{tlx, tly};
    }

  /// get the top left coordinate for a cursor position
  glm::vec2 textCoord(GraphicsContext& gc, Cursor c)
    {
      // TODO change for variable text width fonts
      float text_width = gc.tr.textWidth("a");

      auto coord = lineCoord(gc, c);
      return coord + glm::vec2{(text_width * c.column), 0};
    }
};
