#include "FileBuffer.hpp"

void FileBuffer::render(GraphicsContext& gc)
  {
    double xpos = page.top_left_position.x + page.offset.x;
    double ypos = page.top_left_position.y + page.offset.y;

    for (size_t line_i = 0; line_i < page.buffer.contents.lines.size(); ++line_i)
      {
        StringView line = page.buffer.contents.lines.at(line_i);

        double current_offset = (gc.line_height * page.buffer.line_scroller.position);
        double curr_ypos = current_offset + (ypos + (gc.line_height * line_i));

        if (curr_ypos < (uint64_t)(gc.window->height() + gc.line_height)
         && curr_ypos > (uint64_t)(0))
          {
            if (cursor.line == line_i)
              gc.text(line, xpos, curr_ypos, glm::vec4{1});
            else
              gc.text(line, xpos, curr_ypos, glm::vec4{0.8, 0.8, 0.8, 1});
          }
      }
  }

void FileBuffer::addCursors(GraphicsContext& gc, bool control_mode, bool active)
  {
    // TODO change for variable text width fonts
    float text_width = gc.tr.textWidth("a");

    // change color for active and inactive
    if (active)
      {
        gc.drawRectangle(page.textCoord(gc, cursor), {text_width, gc.line_height},
                         control_mode
                         ? glm::vec4{1, 0.7, 0.7, 0.5}
                         : glm::vec4{0.7, 1, 0.7, 0.5}, 0.4);

        gc.drawRectangle(page.textCoord(gc, shadow_cursor),
                         {text_width, gc.line_height},
                         {0.7, 0.7, 1.0, 0.5}, 0.4);
      }
    else
      {
        gc.drawRectangle(page.textCoord(gc, cursor), {text_width, gc.line_height},
                         control_mode
                         ? glm::vec4{1, 0.7, 0.7, 0.2}
                         : glm::vec4{0.7, 1, 0.7, 0.2}, 0.4);

        gc.drawRectangle(page.textCoord(gc, shadow_cursor),
                         {text_width, gc.line_height},
                         {0.7, 0.7, 1.0, 0.2}, 0.4);

      }

    // TODO investigate positive z layer being below text?
    // - maybe ortho proj doesn't flip?
  }


void FileBuffer::addSearchResults(GraphicsContext& gc)
  {
    // TODO change for variable text width fonts
    float text_width = gc.tr.textWidth("a");

    for (Cursor result : _search.results)
      {
        // SOON this needs to change to update search queries updating better
        gc.drawRectangle(page.textCoord(gc, result),
                         {text_width * _search.common->_query.length(), gc.line_height},
                         glm::vec4{1, 1, 0.3, 0.4}, 0.3);
      }

    // TODO investigate positive z layer being below text?
    // - maybe ortho proj doesn't flip?
  }
