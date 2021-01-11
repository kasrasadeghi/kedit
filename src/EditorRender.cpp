#include "Editor.hpp"

void Editor::render(GraphicsContext& gc)
  {
    gc.alignViewport();
    gc.scissorFull();

    gc.clear(0.5, 0.5, 0.5, 1);
    // CONSIDER: not doing this in render
    currentPage()->scrollToCursor(gc, getCurrentCursor());

    addRectangles(gc);
    gc.renderRectangles();

    auto* page = currentPage();

    // TODO why do we have two scissorRects?
    gc.scissorRect(page->top_left_position, page->size);

    // NOTE: glScissor uses lower left coordinates, (1,1) is first bottom left pixel

    // cut off left and right margin
    gc.scissorRect(page->top_left_position + glm::vec2{0, page->offset.x},
                   glm::vec2{page->size.x - (2 * page->offset.x), page->size.y});

    if (Type::FileBufferT == currentPage()->_type && search_common.active)
      {
        currentFileBuffer()->addSearchResults(gc);
      }

    gc.renderRectangles();

    page->render(gc);

    gc.scissorFull();

    search_common.menu.render(gc);
  }

Cursor Editor::getCurrentCursor(void)
  {
    switch (currentPage()->_type) {
    case Type::FileBufferT: return currentFileBuffer()->cursor;
    case Type::MenuT:
      if (currentMenu()->selectable_lines.empty())
        {
          printerrln("WARNING: Cannot get cursor of menu with no selectable lines");
          return Cursor{0, 0};
        }
      return Cursor{currentMenu()->selectable_lines[currentMenu()->cursor], 0};
    default:
      printerrln("WARNING: Page of type ", currentPage()->_type, " encountered.");
      return Cursor{0, 0};
    }
  }

void Editor::addRectangles(GraphicsContext& gc)
  {
    addBackground(gc);
    if (Type::FileBufferT == currentPage()->_type)
      {
        currentFileBuffer()->addCursors(gc, _control_mode);
      }
    // TODO: fix mouse scrolling
    // - should only scroll to cursor when cursor is interacted with (arrow keys)
    currentPage()->highlightLine(gc, getCurrentCursor());
  }

void Editor::addBackground(GraphicsContext& gc)
  {
    gc.drawRectangle(currentPage()->top_left_position,
                     currentPage()->size, {0.1, 0.1, 0.1, 1}, 0.6);
  }
