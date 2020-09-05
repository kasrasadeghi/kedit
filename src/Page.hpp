#pragma once

#include "PageT.hpp"
#include "Buffer.hpp"
#include "GraphicsContext.hpp"
#include "Cursor.hpp"

#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

// all Pages have a Type from PageT as their first element
// - manual inheritance
struct Page {
  Type _type = Type::NoneT;
  Buffer buffer;

  glm::vec2 offset = {50, 50};
  glm::vec2 top_left_position = {100, 100};
  glm::vec2 size = {1800, 1200};

  glm::vec2 bottomRight(void) { return top_left_position + size; }

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

  void highlightLine(GraphicsContext& gc, Cursor c)
    {
      gc.drawRectangle(lineCoord(gc, c), {1100, gc.line_height}, glm::vec4{1, 1, 0.5, 0.1}, 0.4);
    }

  void scrollToCursor(GraphicsContext& gc, Cursor c)
    {
      // center-follow scrolling mode
      // TODO replace magic number with computation from size and line height
      buffer.line_scroller.target = 13 - ((int64_t)c.line);

      // TODO: other scrolling modes, like
      //   edge-follow: if the cursor is on a line that is below the last visible line, scroll down
      //   near-top: like center, but a different base offset than 13
    }
};
