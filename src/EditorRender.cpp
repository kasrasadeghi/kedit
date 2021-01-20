#include "Editor.hpp"

void Editor::render(GraphicsContext& gc)
  {
    gc.scissorFull();
    gc.alignViewport();
    gc.clear(0.5, 0.5, 0.5, 1);

    // NOTE: disable for now, consider fixing and layering in the future
    glDepthMask(GL_FALSE);

    // render page background and line highlighting
    addBackground(gc);

    auto* page = currentPage();

    // TODO: fix mouse scrolling
    // - should only scroll to cursor when cursor is interacted with (arrow keys)
    // - this falls under the larger umbrella of general mouse mode support
    page->highlightLine(gc, getCurrentCursor());

    // only filebuffer cursor
    addCursors(gc);

    gc.renderRectangles();

    // CONSIDER: not doing this in render
    page->scrollToCursor(gc, getCurrentCursor());

    // only render current page within its margin
    gc.scissorRect(page->top_left_position + page->offset,
                   page->size              - (2.0f * page->offset));

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

    // render search box
    // CONSIDER should maybe move to SearchRender.hpp
    if (search_common.active)
      {
        // draw search box
        gc.drawRectangle(search_common.menu.page.top_left_position,
                         search_common.menu.page.size, {0.2, 0.2, 0.2, 1}, 0.5);

        // render search cursor
        if (Type::FileBufferT == currentPage()->_type)
          {
            search_common.menu.addCursors(gc, _control_mode);
            currentFileBuffer()->addCursors(gc, _control_mode, false);
          }

        gc.renderRectangles();

        search_common.menu.render(gc);
      }

    glDepthMask(GL_TRUE);
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

void Editor::addCursors(GraphicsContext& gc)
  {
    if (Type::FileBufferT == currentPage()->_type)
      {
        if (not search_common.active)
          {
            currentFileBuffer()->addCursors(gc, _control_mode, true);
          }
      }
  }

void Editor::addBackground(GraphicsContext& gc)
  {
    gc.drawRectangle(currentPage()->top_left_position,
                     currentPage()->size, {0.1, 0.1, 0.1, 1}, 0.6);
  }
