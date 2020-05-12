#pragma once

#include "Buffer.hpp"

#include <kgfx/TextRenderer.hpp>
#include <backbone-core-cpp/StrView.hpp>

#include <string>
#include <vector>

struct Editor {
  std::vector<Buffer> _buffers;

  void loadFile(StringView file_path);
  void verticalScroll(double scroll_y);
  void tick(double delta_time);
};
