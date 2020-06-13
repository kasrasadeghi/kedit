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

  inline void render(RenderWindow& window, TextRenderer& tr)
    {
      uint64_t line_number = 0;

      for (StringView line : page.buffer->contents.lines)
        {
          double xpos = 200;
          double current_offset = (30 * page.buffer->line_scroller.position);
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
