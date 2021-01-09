#include "Menu.hpp"

void Menu::render(GraphicsContext& gc)
  {
    double xpos = page.top_left_position.x + page.offset.x;
    double ypos = page.top_left_position.y + page.offset.y;

    for (size_t line_i = 0; line_i < page.buffer.contents.lines.size(); ++line_i)
      {
        StringView line = page.buffer.contents.lines.at(line_i);

        // TODO make text render clip off viewable area
        double current_offset = (gc.line_height * page.buffer.line_scroller.position);
        double curr_ypos = current_offset + (ypos + (gc.line_height * line_i));

        if (curr_ypos < (uint64_t)(gc.window->height() + gc.line_height) && curr_ypos > (uint64_t)(0))
          {
            if (not selectable_lines.empty() && line_i == this->selectable_lines[this->cursor])
              {
                gc.text(line, xpos, curr_ypos, glm::vec4(1, 1, 1, 1));
              }
            else
              {
                gc.text(line, xpos, curr_ypos, glm::vec4(0.7, 0.7, 0.7, 1));
              }
          }
      }
  }
