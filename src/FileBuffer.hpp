#pragma once

#include "Buffer.hpp"
#include "PageT.hpp"
#include "Page.hpp"

#include <backbone-core-cpp/File.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

#include <string>

struct FileBuffer {
  Page page;

  File file;
  StringView file_contents = "";

  inline bool invariant()
    { return file_contents._length > 0 && file_contents._length > page.buffer->contents.length(); }

  inline void render(GraphicsContext& gc)
    {
      uint64_t line_number = 0;

      double xpos = page.position.x + 50;
      double ypos = page.position.y + 50;

      for (StringView line : page.buffer->contents.lines)
        {
          double current_offset = (30 * page.buffer->line_scroller.position);
          double curr_ypos = current_offset + (ypos + (30 * line_number));

          // TODO "+ 30" should be "+ text_height"
          if (curr_ypos < (uint64_t)(gc.window->height() + 30) && curr_ypos > (uint64_t)(0))
            {
              gc.text(line.stringCopy(), xpos, curr_ypos, 1);
            }
          ++ line_number;
        }
    }
};
