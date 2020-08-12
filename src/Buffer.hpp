#pragma once

#include "Rope.hpp"
#include "Scroller.hpp"

#include <backbone-core-cpp/File.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

#include <string>

struct Buffer {
  ViewRope contents;
  Scroller line_scroller;

  inline void tick(double delta_time)
    { line_scroller.tick(delta_time); }
};
