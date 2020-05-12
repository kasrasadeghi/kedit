#pragma once

#include "Rope.hpp"

#include <backbone-core-cpp/File.hpp>

#include <string>

struct Buffer {
  File file;
  StringView file_contents = "";
  Rope contents;
  double scroll_offset = 0;
};
