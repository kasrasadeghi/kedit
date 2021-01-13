#include "Editor.hpp"

void Editor::render(GraphicsContext& gc)
  {
    gc.scissorFull();
    gc.alignViewport();
    gc.clear(0.5, 0.5, 0.5, 1);

    // render page background and line highlighting
    addRectangles(gc);
    gc.renderRectangles();

    auto* page = currentPage();

    // CONSIDER: not doing this in render
    page->scrollToCursor(gc, getCurrentCursor());

    // only render current page within its margin
    gc.scissorRect(page->top_left_position + glm::vec2{0, page->offset.x},
                   glm::vec2{page->size.x - (2 * page->offset.x), page->size.y});

    // CONSIDER: combining searchbox and search result rendering somehow?
    // - search box rendering should go afterwards to be "on top"
    // render search results
    if (Type::FileBufferT == currentPage()->_type && search_common.active)
      {
        currentFileBuffer()->addSearchResults(gc);
        gc.renderRectangles();
      }

    // render page text
    page->render(gc);
    gc.renderRectangles();

    // render search box
    if (search_common.active)
      {
        // TODO do this only once, not every frame
        // - need access to the graphics context
        auto& tl     = search_common.menu.page.top_left_position;
        auto& offset = search_common.menu.page.offset;
        auto& size   = search_common.menu.page.size;

        auto SL = 300; // search box length
        offset = {gc.line_height, gc.line_height};
        tl = {1800 - SL, 150};
        size = {SL, 1.5 * gc.line_height};

        // draw search box
        gc.drawRectangle(search_common.menu.page.top_left_position,
                         search_common.menu.page.size, {0.2, 0.2, 0.2, 1}, 0.5);

        gc.renderRectangles();

        search_common.menu.render(gc);
      }
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
