#pragma once

#include "Rope.hpp"
#include "Scroller.hpp"

#include <backbone-core-cpp/File.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

#include <string>

struct Buffer {
  File file;
  StringView file_contents = "";
  Rope contents;
  Scroller line_scroller;

  void tick(double delta_time)
    { line_scroller.tick(delta_time); }

  void render(RenderWindow& window, TextRenderer& tr)
    {
      uint64_t line_number = 0;

      for (StringView line : contents.lines)
        {

          double xpos = 200;
          double current_offset = (30 * line_scroller.position);
          double ypos = current_offset + (50 + (30 * line_number));

          // TODO "+ 30" should be "+ text_height"
          if (ypos < (uint64_t)(window.height() + 30) && ypos > (uint64_t)(0))
            {
              tr.renderText(line.stringCopy(), 200, ypos, 1);
            }
          ++ line_number;
        }
    }
};
