#pragma once

#include "Rope.hpp"
#include "Scroller.hpp"

#include <backbone-core-cpp/File.hpp>

#include <string>

struct Buffer {
  File file;
  StringView file_contents = "";
  Rope contents;

  Scroller line_scroller;

  void tick(double delta_time)
    { line_scroller.tick(delta_time); }
};
